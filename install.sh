#!/usr/bin/env bash
# Deploy rules and skills from this repo into ~/.claude/
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Deploying from $REPO_DIR → $CLAUDE_DIR"

# Rules
mkdir -p "$CLAUDE_DIR/rules"
cp "$REPO_DIR"/rules/*.md "$CLAUDE_DIR/rules/"
echo "  rules/ — $(ls "$REPO_DIR"/rules/*.md | wc -l) files"

# Skills
mkdir -p "$CLAUDE_DIR/skills"
for skill in "$REPO_DIR"/skills/*/; do
  name=$(basename "$skill")
  mkdir -p "$CLAUDE_DIR/skills/$name"
  cp -r "$skill"* "$CLAUDE_DIR/skills/$name/"
  echo "  skills/$name/"
done

echo "Done."
