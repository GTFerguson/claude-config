# Prompt Toolbox

A collection of battle-tested prompts for codebase analysis, documentation, and remediation. Each prompt is a self-contained methodology that guides AI through a complex multi-step task.

## Prompts

| Prompt | Purpose |
|--------|---------|
| [code-review](prompts/code-review.md) | Systematic code quality review — security, SOLID, performance, error handling. Produces scored component reviews, issue tracking, and remediation roadmap. |
| [codebase-docs](prompts/codebase-docs.md) | Generate architecture documentation in a standard `docs/` structure from a codebase scan. Also supports cross-project analysis and consolidation proposals. |

## Playbook

Execution methodology for acting on audit findings — orchestrating multi-phase remediation programs across sessions.

| Document | Purpose |
|----------|---------|
| [playbook/README](playbook/README.md) | Quick start |
| [playbook/architecture](playbook/architecture.md) | 3-layer orchestrator hierarchy |
| [playbook/quality-gates](playbook/quality-gates.md) | Checkpoint definitions |
| [playbook/context-management](playbook/context-management.md) | Managing AI context across sessions |

### Task Prompts

| Prompt | Purpose |
|--------|---------|
| [security-fix](playbook/prompts/security-fix.md) | Fix a specific security vulnerability with checklist and common patterns |
| [package-extraction](playbook/prompts/package-extraction.md) | Extract shared code into a reusable package |
| [component-migration](playbook/prompts/component-migration.md) | Migrate a component to use shared packages |
| [test-generation](playbook/prompts/test-generation.md) | Generate tests for a component |
| [master-orchestrator-init](playbook/prompts/master-orchestrator-init.md) | Initialize a remediation program |
| [phase-orchestrator-init](playbook/prompts/phase-orchestrator-init.md) | Initialize a phase within a program |
| [context-restore](playbook/prompts/context-restore.md) | Restore context after a session break |

## Origin

These prompts were refined across multiple real codebase audits producing hundreds of pages of structured findings. The code review methodology in particular was iterated across 6 codebases and proven to consistently produce actionable, evidence-backed output.
