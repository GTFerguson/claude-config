# Claude Config

Portable Claude Code configuration — rules, skills, and prompts.

- `rules/` — Global coding standards, deployed to `~/.claude/rules/`
- `skills/` — Claude Code skills (`/review-codebase`, `/document-codebase`, `/update-plans`)
- `prompts/` — Operation and orchestration prompts
- `install.sh` — Deploy rules and skills into `~/.claude/`

Edit files here, commit and push, then run `./install.sh` to deploy.
