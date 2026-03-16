# Claude Setup

Portable Claude Code configuration — rules, skills, and prompts. Clone onto any machine, symlink into `~/.claude/`, and everything works.

## Structure

```
rules/                              # Global coding standards
skills/                             # Claude Code skills (/slash-commands)
prompts/
├── tasks/                          # Specific operation prompts
└── orchestration/                  # Multi-session scaffolding
```

## Installation

```bash
git clone git@github.com:GTFerguson/claude-setup.git ~/.claude-setup

# Symlink rules
ln -s ~/.claude-setup/rules/* ~/.claude/rules/
```

## Rules

| Rule | What It Enforces |
|------|-----------------|
| [code-comments](rules/code-comments.md) | Comments explain WHY not WHAT, no internal references |
| [code-intel](rules/code-intel.md) | nkrdn knowledge graph — when and how to query code structure |
| [markdown-formatting](rules/markdown-formatting.md) | Obsidian compatibility — blank lines before tables, callouts, mermaid |
| [proven-documentation](rules/proven-documentation.md) | PROVEN principles — provenance, research-first, verifiable, evidence-tiered |
| [test-driven-debugging](rules/test-driven-debugging.md) | Write tests to diagnose bugs, not read-and-guess |

## Skills

| Skill | Purpose |
|-------|---------|
| [/review-codebase](skills/review-codebase.md) | Systematic code quality review — security, SOLID, performance, scoring, remediation roadmap |
| [/document-codebase](skills/document-codebase.md) | Generate architecture docs in standard `docs/` structure from codebase scan |

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
