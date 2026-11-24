---
id: project-ai-profile
type: project
tags: [档案, 跨AI平台, Git]
status: active
updated: 2026-11-24
source: AI对话
confidence: high
---

# 跨 AI 平台个人档案库

## 一句话

用 Git 私有库 `hailongli817-debug/ai-profile` 存一份所有 AI 平台共读的个人事实，不再各记各的。

## 现状

- 已完成：目录结构与读写规范（AGENTS.md）、索引、三类 profile、inbox 按平台隔离、packs 自动打包脚本。
- 已完成：2026-11-24 通过本机 git clone 接入私有库，确认 main 分支可读写。
- 进行中：把本地环境与账号事实收敛进正式文件，补齐本平台的接入说明。
- 卡在：本平台 GitHub 连接器的授权范围未覆盖该私有库，API 读取返回 404，暂走本机 git 通道。

## 下一步

1. 在 GitHub 应用授权里把 `ai-profile` 加入可访问仓库，或统一以本机 git clone 作为各平台通道。
2. 按模板补 `projects/` 业务项目与 `people/` 关键联系人，每类至少一个实例。
3. 建 `private/local.md` 存敏感信息，确认 .gitignore 生效。

## 关键约束

- 仓库为 private；健康、家庭关系、客户报价只进 `private/`，永不上传。
- AI 只写 `inbox/<平台>/`，正式文件收敛需用户授权；不 push --force、不改历史、不删别人的 inbox。
- 单个知识文件 ≤ 40 行，带 YAML front-matter。

## 相关文件

- 本地路径：`C:/Users/Li/WorkBuddy/2026-11-24-12-03-32/ai-profile`
- 线上链接：https://github.com/hailongli817-debug/ai-profile
