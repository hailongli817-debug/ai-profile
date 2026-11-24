# AGENTS.md — 本仓库的读取与写入约定

> 任何 AI（Claude / Codex / Cursor / ChatGPT / 豆包 等）接入本仓库，先读完本文件再动手。
> 这就是"个人档案"的接口规范。

## 0. 这是什么

单人长期个人档案：事实用纯 Markdown 存，版本和冲突用 Git 管。
目的：不同 AI 平台读到同一份关于用户的真相，不再各记各的。

## 1. 读的顺序

1. 先读 `index.md`，它是全库索引，每个文件一句话。
2. 按 index 里的 `type` 挑需要的文件，**只读相关的那几个**。
3. 需要快速建立整体印象时，读 `packs/core.md`（浓缩版，约 3000 字）。

禁止无差别遍历整个仓库。档案变大以后，靠 index 定位是唯一可持续的读法。

## 2. 文件格式

每个知识文件必须有 YAML front-matter：

```yaml
---
id: pref-reply-style
type: preference        # identity | business | preference | project | person | health | log | inbox
tags: [风格, 语言]
updated: 2026-11-24
source: 用户口述        # 用户口述 | AI对话 | 文档 | 推断
confidence: high        # high | medium | low
---
```

写作规则：

- 一个文件一个主题，控制在 40 行以内；超了就拆。
- 只写结论和事实，不写推理过程和对话经过。
- `confidence: low` 或 `source: 推断` 的内容，AI 引用时必须说明"这条不确定"。
- `memory/` 下的日志只追加，不修改既有内容。

## 3. 写：唯一合法方式

AI **不能**直接改 `profile/`、`projects/`、`people/`、`index.md`。

只能写这个位置：

```
inbox/<平台名>/<YYYY-MM-DD>-<主题>.md
```

例：`inbox/chatgpt/2026-11-24-选题偏好补充.md`

内容格式（同样带 front-matter）：

```markdown
---
type: inbox
platform: chatgpt
created: 2026-11-24
suggest_target: profile/preferences.md
---

- 新增或更正的事实，一条一行，不要写背景故事。
```

原因：多个 AI 同时直改正式文件必然冲突。inbox 按平台隔离，永不冲突。
把 inbox 收敛进正式文件，是用户（或用户授权的整理任务）的事。

## 4. 绝对不要做

- 不写入密钥、密码、身份证号、银行卡、客户报价明细。
- 不读不写 `private/`（被 .gitignore 排除，可能根本不存在）。
- 不 `git push --force`，不改历史，不删别人的 inbox。
- 不在正式文件里留"待确认""TODO"——不确定就标 `confidence: low`。

## 5. 提交信息

`[<平台>] <动作>: <对象>`

例：`[claude] add: 客户沟通偏好`、`[doubao] fix: 业务范围表述`
