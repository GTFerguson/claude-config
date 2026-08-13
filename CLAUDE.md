# Claude Config

Portable Claude Code configuration — rules, skills, and prompts.

This repo is cloned in place at `~/.claude` — it *is* the live config directory. Edits take
effect immediately; there is no deploy step.

- `rules/` — Global coding standards, loaded into every session
- `skills/` — Claude Code skills, one directory per skill (see README for the full list)
- `prompts/` — Operation and orchestration prompts
- `shell/` — Shell integration sourced from `~/.bashrc`

Edit files here, then commit and push to share them with your other machines.
