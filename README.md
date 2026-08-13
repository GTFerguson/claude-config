# Claude Config

Portable Claude Code configuration — rules, skills, and prompts.

## Structure

This repo is cloned **in place at `~/.claude`** — it is the live config directory, not a
staging copy of one. Editing a file here changes Claude Code's behaviour immediately; there
is no deploy step.

```
rules/                              # loaded into every session
skills/                             # one dir per skill, each with a SKILL.md
prompts/
├── tasks/                          # Specific operation prompts
└── orchestration/                  # Multi-session scaffolding
shell/                              # sourced from ~/.bashrc
└── claude-resume.sh                # auto-resume claude from latest /handoff brief
```

Everything else under `~/.claude` — `projects/`, `memory/`, `settings.json`, caches — is
runtime state. `.gitignore` ignores everything by default and whitelists only the
directories above, so that state stays out of the repo.

## Installation

On a new machine, clone directly over the config directory:

```bash
git clone git@github.com:GTFerguson/claude-config.git ~/.claude
```

If `~/.claude` already exists with runtime state in it, clone elsewhere and move the `.git`
directory plus tracked content into place rather than deleting it.

After editing rules or skills, commit and push — the changes are already live locally.

## Rules

| Rule | What It Enforces |
|------|-----------------|
| [code-comments](rules/code-comments.md) | Comments explain WHY not WHAT, no internal references |
| [code-intel](rules/code-intel.md) | nkrdn knowledge graph — when and how to query code structure |
| [markdown-formatting](rules/markdown-formatting.md) | Obsidian compatibility — blank lines before tables, callouts, mermaid |
| [proven-documentation](rules/proven-documentation.md) | PROVEN principles — provenance, research-first, verifiable, evidence-tiered |
| [scout-browse](rules/scout-browse.md) | Browser automation via `scout-browse`; recovering a profile that won't launch |
| [test-driven-debugging](rules/test-driven-debugging.md) | Write tests to diagnose bugs, not read-and-guess |

## Skills

**Documentation & planning**

| Skill | Purpose |
|-------|---------|
| [/document-codebase](skills/document-codebase/SKILL.md) | Generate architecture docs in standard `docs/` structure from codebase scan |
| [/focus](skills/focus/SKILL.md) | Assess and organise docs for one topic, surface phase status, give an exec overview |
| [/handoff](skills/handoff/SKILL.md) | Write a session-handoff brief so work resumes with zero rediscovery cost |
| [/update-plans](skills/update-plans/SKILL.md) | Audit plan docs — verify shipped phases, stub completed work, delete finished plans |
| [/weekly-report](skills/weekly-report/SKILL.md) | Leadership-facing progress report from git history and dev-logs, plus optional slide deck |

**Review**

| Skill | Purpose |
|-------|---------|
| [/review-codebase](skills/review-codebase/SKILL.md) | Systematic code quality review — security, SOLID, performance, scoring, remediation roadmap |
| [/review-tests](skills/review-tests/SKILL.md) | Test suite review — structure, DRY, assertion quality, dead tests, fixture hygiene |
| [/visual-audit](skills/visual-audit/SKILL.md) | Screenshot every screen at mobile and desktop, report overflow, clipping, contrast |

**Research & writing**

| Skill | Purpose |
|-------|---------|
| [/proven-research](skills/proven-research/SKILL.md) | PROVEN-quality research via alphaxiv, PubMed and web, written up as cited reference docs |
| [/humanize-text](skills/humanize-text/SKILL.md) | Strip LLM tells from AI-drafted prose while preserving meaning and limits |

**Design & presentation**

| Skill | Purpose |
|-------|---------|
| [/design-bible](skills/design-bible/SKILL.md) | Create or update a project's design bible — visual language, components, voice |
| [/frontend-slides](skills/frontend-slides/SKILL.md) | Animation-rich HTML presentations from scratch or converted from PowerPoint |
| [/pitch-deck](skills/pitch-deck/SKILL.md) | Create or update pitch decks for Cognetic products |

**Tooling**

| Skill | Purpose |
|-------|---------|
| [/code-intel](skills/code-intel/SKILL.md) | Orient with the nkrdn knowledge graph before diving into grep/read |
| [/scout-browse](skills/scout-browse/SKILL.md) | Browser automation via Patchright with persistent profile and CAPTCHA solver |
| [/playwright](skills/playwright/SKILL.md) | Browser automation via `playwright-cli` — fallback for when `/scout-browse` misbehaves |

## Task Prompts

| Prompt | Purpose |
|--------|---------|
| [security-fix](prompts/tasks/security-fix.md) | Fix a vulnerability with checklist and common patterns |
| [test-generation](prompts/tasks/test-generation.md) | Generate tests for a component |
| [package-extraction](prompts/tasks/package-extraction.md) | Extract shared code into reusable package |
| [component-migration](prompts/tasks/component-migration.md) | Migrate component to shared packages |

## Orchestration

For working through large codebases systematically across multiple sessions.

| Prompt | Purpose |
|--------|---------|
| [quality-gates](prompts/orchestration/quality-gates.md) | Checkpoint definitions and pass criteria |
| [context-management](prompts/orchestration/context-management.md) | Managing AI context across sessions |
| [context-restore](prompts/orchestration/context-restore.md) | Restore context after a session break |
| [master-orchestrator-init](prompts/orchestration/master-orchestrator-init.md) | Initialize a multi-phase program |
| [phase-orchestrator-init](prompts/orchestration/phase-orchestrator-init.md) | Initialize a phase within a program |

## Shell Integration

`shell/claude-resume.sh` wraps the `claude` command so that when an interactive
session exits and the project has a fresh `docs/plans/handoff/<slug>.md` brief
(from the `/handoff` skill), it relaunches in the same terminal seeded with
`claude "Read <brief> and resume…"`. The brief path is submitted as the first
turn, so the resumed session starts working with no copy-paste or `/clear`.

The repo is in place at `~/.claude`, so the script is sourced directly:

```bash
[ -f ~/.claude/shell/claude-resume.sh ] && . ~/.claude/shell/claude-resume.sh
```

Guards: resumes once per `/handoff` (a marker in `~/.cache/cade-resume/`), only
for briefs newer than `CADE_RESUME_WINDOW` seconds (default 1800), and never for
`claude -p`/non-interactive use. `resume` is a manual command to jump back into
the latest brief on demand.
