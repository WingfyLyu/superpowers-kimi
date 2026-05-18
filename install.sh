#!/bin/bash
set -euo pipefail

SKILLS_DIR="${HOME}/.kimi/skills"
mkdir -p "$SKILLS_DIR"

# 将本仓库的 skills/ 下的所有 skill 软链接到 ~/.kimi/skills/
for skill_dir in skills/*/; do
    name=$(basename "$skill_dir")
    target="$SKILLS_DIR/$name"
    if [[ -L "$target" ]]; then
        rm "$target"
    elif [[ -e "$target" ]]; then
        echo "警告: $target 已存在且不是软链接，跳过"
        continue
    fi
    ln -s "$(pwd)/$skill_dir" "$target"
    echo "已链接: $name"
done

echo "安装完成。重启 Kimi Code CLI 或新开会话即可生效。"
