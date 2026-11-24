# inbox — AI 写入区

规则见 `AGENTS.md` 第 3 节。要点：

- 一个平台一个目录：`chatgpt/`、`claude/`、`doubao/`、`workbuddy/`、`other/`
- 一次写入一个文件：`<YYYY-MM-DD>-<主题>.md`
- 必须带 front-matter，`type: inbox`，并写 `suggest_target`
- 只写"要新增或更正的事实"，不写过程

收敛流程：人工（或授权任务）读 inbox → 合并进 `profile/` / `projects/` → 删掉 inbox 文件 → 同一次提交里更新 `index.md`。
