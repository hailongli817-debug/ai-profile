# 接入清单：ChatGPT / Grok / Gemini

目标仓库：`hailongli817-debug/ai-profile`（private）
三家都走 MCP，但**认证方式不一样**，写权限的天花板也不一样。先把结论看一遍，再照着做。

## 结论表

| 平台 | 接入方式 | 读 | 写 | 卡点 |
|---|---|---|---|---|
| ChatGPT | 官方 GitHub 连接器（OAuth） | 是 | **否** | 个人 Pro 版只给读，完整 MCP 写入限 Business / Enterprise / Edu |
| ChatGPT（备用） | 自定义 MCP → GitHub 远程端点 | 是 | 同上 | 需开发者模式，Pro 版仍限只读 |
| Grok | grok.com/connectors → GitHub（OAuth） | 是 | 视连接器授权范围，进 app 实测 | 无需配置，点选即可 |
| Grok（备用） | New Connector → Custom → MCP URL | 是 | 视 PAT 范围 | 需要公网可达的 MCP 端点 |
| Gemini | 本机 Antigravity CLI + GitHub MCP（PAT） | 是 | **是** | 需要一个细粒度 PAT |

一句话：**Gemini 这条线能真做到读写；ChatGPT 个人版只能读；Grok 要实测。**

---

## 1. 先建令牌（Gemini 和 Grok 备用都靠它）

GitHub → Settings → Developer settings → Personal access tokens → **Fine-grained tokens** → Generate new token。

必须这样填，别图省事给 classic token：

| 项 | 值 |
|---|---|
| Token name | `ai-profile-mcp` |
| Expiration | 90 天 |
| Repository access | Only select repositories → 只勾 `ai-profile` |
| Permissions → Contents | Read and write |
| Permissions → Metadata | Read（必选，自动带上） |

生成后只显示一次，复制好。

> 为什么不用 `repo` 全权限的经典令牌：这个令牌会被三家的 AI 用，一旦范围是全账号，等于把名下所有仓库的读写权交出去。只给一个仓库，出事也只影响这一份档案。

---

## 2. Gemini（Antigravity CLI）— 已配好，只差令牌

本机 `agy` 已安装，配置文件已经写在这里：

```
%USERPROFILE%\.gemini\config\mcp_config.json
```

里面只放了一条 `github-profile`，指向 GitHub 托管的远程端点：

```
https://api.githubcopilot.com/mcp/
```

令牌通过环境变量 `${GITHUB_PERSONAL_ACCESS_TOKEN}` 注入，不写进配置文件。

> 为什么不用本地 stdio：网上不少教程写 `npx -y @github/github-mcp-server`，但这个 npm 包并不存在（实测 404），本机也没装 Docker。远程端点不需要本地运行时，反而省事。

设置令牌：

```powershell
powershell -ExecutionPolicy Bypass -File C:\Users\Li\ai-profile\tools\set-github-token.ps1
```

脚本会要你粘贴令牌（不回显），校验账号和仓库可读后写入用户环境变量 `GITHUB_PERSONAL_ACCESS_TOKEN`。

然后验证：

```powershell
agy mcp list
```

看到 `github-profile` 是 Connected 就通了。

连不上的两种情况：

- 401 / 403：Antigravity 没把 `${GITHUB_PERSONAL_ACCESS_TOKEN}` 展开成实际值。改用命令行写入：
  ```powershell
  agy mcp add --header "Authorization: Bearer $env:GITHUB_PERSONAL_ACCESS_TOKEN" github-profile https://api.githubcopilot.com/mcp/
  ```
- 超时：公司网络或代理拦了 `api.githubcopilot.com`，换网络再试。

**写权限确认**：让 `agy` 往 `inbox/gemini/` 写一个文件，再在本机 `git pull`，看到新文件就是开了。没看到就是只读，回到第 1 步检查 Contents 是否给了 write。

---

## 3. Grok

1. 打开 `grok.com/connectors`
2. 找到 **GitHub**，点连接，完成 OAuth 授权（选 `ai-profile` 这个仓库，或允许全部，取决于授权页给的选项）
3. 回到对话，粘贴 `connect/bootstrap-prompt.md` 里的开场提示词

写入能力：xAI 的 GitHub 连接器主要面向读（搜索代码、汇总 PR、看改动）。要写就往下面的备用方案走。

**Grok 备用（自定义 MCP）**：
1. `grok.com/connectors` → New Connector → Custom
2. 填 MCP 服务器 URL，认证方式填 Bearer + 第 1 步的 PAT
3. 保存后 Grok 会扫描可用工具

注意：Grok 的自定义连接器要求**公网可达的 HTTPS 端点**，本机跑的服务需要先做隧道（cloudflared / ngrok）。所以优先用官方 GitHub 连接器，别为了写权限折腾隧道。

---

## 4. ChatGPT

**主路（推荐，两分钟）**
1. Settings → Plugins（连接器）
2. 加 GitHub
3. OAuth 授权
4. 对话里贴开场提示词

这一条是只读的：能读文件、搜代码，不能改。

**备路（自定义 MCP）**
1. Settings → Security and login → 打开 Developer mode
2. Plugins 页 → 加号 → 新增自定义 MCP 服务器
3. URL 填 `https://api.githubcopilot.com/mcp/`
4. 认证选 Bearer + PAT（若客户端只给 OAuth / 无认证，说明这版不支持静态令牌，退回主路）

**关于写**：OpenAI 官方文档写明，个人 Pro 号在开发者模式下只能连"读/取"权限的 MCP，完整 MCP（含写入）限 Business / Enterprise / Edu。想真让 ChatGPT 改档案，只有两个办法：

- 升到 Business 及以上
- 用 **Codex** 在本地跑（它对你的仓库有写权）

现实做法：让 ChatGPT 只读，需要改的地方让它输出内容，你贴回豆包这边，由我提交。

---

## 5. 三家共用的一条规矩

不管哪家，**只能写 `inbox/<平台>/`**，这条写在 `AGENTS.md` 里，接入后 AI 会自己读到。真正的合并仍然手动做，避免三边同时改一个文件打出冲突。

## 6. 安全清单

- [ ] PAT 只勾 `ai-profile` 一个仓库，90 天有效
- [ ] 令牌只放环境变量，不进仓库、不进聊天记录
- [ ] ChatGPT / Grok 的 OAuth 授权页，能选单仓库就选单仓库
- [ ] 每 90 天轮换一次 PAT
- [ ] 发现哪个 AI 改动异常，先 `git log` 看提交来源，再吊销令牌
