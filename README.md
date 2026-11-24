# AI 个人档案

一份用 Git 管起来、任何 AI 都能读的个人档案。目标不是"让某个平台记住我"，而是让所有平台读到同一份真相。

## 目录

| 路径 | 作用 |
|---|---|
| `AGENTS.md` | 给 AI 的读写规则，所有工具的入口 |
| `index.md` | 索引，AI 先读这个定位文件 |
| `profile/` | 稳定事实：身份、业务、偏好 |
| `projects/` | 进行中的项目，一项目一文件 |
| `people/` | 关键联系人 |
| `memory/` | 按日追加的日志 |
| `inbox/` | 各 AI 平台的写入区，按平台隔离 |
| `packs/core.md` | 自动生成的浓缩上下文包，用于粘贴 |
| `tools/pack.py` | 生成 packs 的脚本 |
| `private/` | 本地专用，已被 .gitignore 排除，不上传 |

## 日常怎么用

```powershell
# 取回其他设备/平台的最新改动
git pull --rebase

# 把 inbox 收敛进正式文件后提交
git add -A
git commit -m "[整理] merge: inbox 收敛"
git push
```

生成一次上下文包（给不支持 MCP 的聊天窗口粘贴用）：

```powershell
python tools\pack.py
```

## 各平台怎么接

| 平台 | 读 | 写 | 方式 |
|---|---|---|---|
| Claude Desktop / Claude Code | 是 | 是 | GitHub MCP |
| Cursor / VS Code / Windsurf | 是 | 是 | GitHub MCP |
| ChatGPT | 是 | 需 Codex 或自定义 MCP connector | GitHub 连接器只读 |
| 豆包工作台 | 是 | 是 | 本地 clone，直接读写 |
| 网页版聊天（Kimi / 元宝 等） | 否 | 否 | 粘贴 `packs/core.md` |

## 隐私

仓库设为 private。健康、家庭、客户报价这类内容只放 `private/`，永不上传。
推公开镜像前，先跑一遍脱敏。
