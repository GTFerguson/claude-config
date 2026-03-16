# Prompt Toolbox

Collection of reusable prompts for codebase analysis, documentation generation, and remediation execution.

## Prompts

- `prompts/code-review.md` — Systematic code quality review methodology
- `prompts/codebase-docs.md` — Generate architecture docs in standard `docs/` structure
- `playbook/` — Orchestrated remediation execution with quality gates

## Output Conventions

All prompt output follows Obsidian-compatible markdown:

- YAML frontmatter on every document (title, created, updated, status, tags)
- Blank line before all tables
- Wiki-links `[[path/to/doc]]` for cross-references
- Callouts: `> [!CRITICAL]`, `> [!WARNING]`, `> [!TIP]`, `> [!NOTE]`, `> [!IMPORTANT]`
- Mermaid diagrams for architecture, data flow, dependency graphs
- Code evidence includes file path and line number
