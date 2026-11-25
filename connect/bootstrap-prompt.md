# 开场提示词

接入仓库后，在新的对话里先发这一段。各家都适用，只改平台名。

---

## 通用版

```text
我的个人档案在 GitHub 仓库 hailongli817-debug/ai-profile（private）。

读取顺序：
1. 先读 AGENTS.md，按里面的规则执行。
2. 再读 index.md，按 type 只取需要的文件，不要遍历全库。

写入规则：
- 你有写权限时，只能新建文件到 inbox/<平台名>/ 下，文件名 <YYYY-MM-DD>-<主题>.md，带 front-matter。
- 不要修改 profile/、projects/、people/、index.md。
- 不要读 private/。

以后凡涉及我的偏好、业务背景、项目状态的问题，先查这个仓库再回答；查不到就说查不到，不要编。
```

## Grok 版

把 `<平台名>` 换成 `grok`。若没有写权限，在上面的写入规则后面补一句：

```text
你没有写权限时，把要更新的内容整理成上面那种格式打印给我，我自己提交。
```

## ChatGPT 版

把 `<平台名>` 换成 `chatgpt`。建议在自定义指令里也存一份精简版，省得每次贴。

## Gemini / Antigravity 版

把 `<平台名>` 换成 `gemini`。Antigravity CLI 会自动读项目内的 `AGENTS.md`，这段主要用来明确"只写 inbox"。
