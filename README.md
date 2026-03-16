# Claude Setup

Portable Claude Code configuration — rules, prompts, and skills. Clone onto any machine, symlink into `~/.claude/`, and everything works.

## Structure

```
rules/                             # Global coding standards
├── code-comments.md               # WHY not WHAT, no marker comments
├── code-intel.md                  # nkrdn code knowledge graph usage
├── markdown-formatting.md         # Obsidian-compatible formatting
├── proven-documentation.md        # PROVEN principles for reference docs
└── test-driven-debugging.md       # Test-first debugging methodology

prompts/                           # Methodology prompts and task templates
├── code-review.md                 # /review-codebase skill
├── codebase-docs.md               # /document-codebase skill
├── security-fix.md                # Fix a specific vulnerability
├── test-generation.md             # Generate tests for a component
├── package-extraction.md          # Extract shared code into a package
├── component-migration.md         # Migrate component to shared packages
├── quality-gates.md               # Checkpoint definitions and pass criteria
├── context-management.md          # Managing AI context across sessions
├── context-restore.md             # Restore context after session break
├── master-orchestrator-init.md    # Initialize a multi-phase program
└── phase-orchestrator-init.md     # Initialize a phase within a program
```

## Installation

```bash
git clone git@github.com:GTFerguson/claude-setup.git ~/.claude-setup

# Symlink rules into Claude Code global rules
ln -s ~/.claude-setup/rules/* ~/.claude/rules/
```

## Rules

| Rule | What It Enforces |
|------|-----------------|
| [code-comments](rules/code-comments.md) | Comments explain WHY not WHAT, no internal references, self-contained |
| [code-intel](rules/code-intel.md) | nkrdn knowledge graph — when and how to query code structure |
| [markdown-formatting](rules/markdown-formatting.md) | Obsidian compatibility — blank lines before tables, callouts, mermaid |
| [proven-documentation](rules/proven-documentation.md) | PROVEN principles — provenance, research-first, verifiable, evidence-tiered |
| [test-driven-debugging](rules/test-driven-debugging.md) | Write tests to diagnose bugs, not read-and-guess |

## Skills

| Prompt | Skill | Purpose |
|--------|-------|---------|
| [code-review](prompts/code-review.md) | `/review-codebase` | Systematic code quality review — security, SOLID, performance, scoring, remediation |
| [codebase-docs](prompts/codebase-docs.md) | `/document-codebase` | Generate architecture docs in standard `docs/` structure from codebase scan |

## Task Prompts

| Prompt | Purpose |
|--------|---------|
| [security-fix](prompts/security-fix.md) | Fix vulnerability with checklist and common patterns |
| [test-generation](prompts/test-generation.md) | Generate tests for a component |
| [package-extraction](prompts/package-extraction.md) | Extract shared code into reusable package |
| [component-migration](prompts/component-migration.md) | Migrate component to shared packages |

## Scaffolding

For working through large codebases systematically across multiple sessions.

| Prompt | Purpose |
|--------|---------|
| [quality-gates](prompts/quality-gates.md) | Checkpoint definitions and pass criteria |
| [context-management](prompts/context-management.md) | Managing AI context across sessions |
| [context-restore](prompts/context-restore.md) | Restore context after a session break |
| [master-orchestrator-init](prompts/master-orchestrator-init.md) | Initialize a multi-phase remediation program |
| [phase-orchestrator-init](prompts/phase-orchestrator-init.md) | Initialize a phase within a program |
