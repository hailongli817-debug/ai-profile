#!/usr/bin/env python3
"""把档案压成一份可直接粘贴的上下文包：packs/core.md"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CORE = [
    "profile/identity.md",
    "profile/business.md",
    "profile/preferences.md",
]
OUT = ROOT / "packs" / "core.md"
MAX_CHARS = 6000


def read(path: Path):
    try:
        return path.read_text(encoding="utf-8").strip()
    except FileNotFoundError:
        return None


def active_projects():
    items = []
    for f in sorted((ROOT / "projects").glob("*.md")):
        if f.name.startswith("_"):
            continue
        text = read(f)
        if text and re.search(r"^status:\s*active", text, re.M):
            items.append(text)
    return items


def main():
    parts = []
    for rel in CORE:
        t = read(ROOT / rel)
        if t:
            parts.append(t)
    parts.extend(active_projects())

    header = (
        "# 我的个人档案（自动生成的上下文包）\n\n"
        "> 这是浓缩版。完整档案在 Git 仓库里，本文件用于粘贴到不支持 MCP 的聊天窗口。\n\n"
    )
    body = "\n\n---\n\n".join(parts)
    text = header + body

    if len(text) > MAX_CHARS:
        text = header + body[:MAX_CHARS] + "\n\n（已截断，完整内容见仓库）\n"

    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(text, encoding="utf-8")
    print(f"已生成 {OUT}")
    print(f"{len(text)} 字符，约 {len(text) // 2} tokens")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"失败: {e}", file=sys.stderr)
        sys.exit(1)
