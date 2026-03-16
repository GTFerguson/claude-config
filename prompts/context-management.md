---
title: Context Management
created: 2026-03-16
updated: 2026-03-16
status: active
tags: [playbook, context, sessions]
---

# Context Management

## The Problem

AI assistants have finite context windows. Long-running projects span multiple sessions, and context degrades within sessions as the window fills. This document defines strategies to maintain coherence across sessions.

## State Files

State files are the primary mechanism for persisting context across sessions.

### Master State File

Tracks program-level progress:

```markdown
# Master Orchestrator State

## Program Overview
- **Current Phase**: {phase}
- **Overall Progress**: {%}

## Phase Status
| Phase | Status | Progress | Notes |
|-------|--------|----------|-------|

## Active Sub-Orchestrators
| Orchestrator | Phase | Status | State File |
|--------------|-------|--------|------------|

## Checkpoint Status
| Checkpoint | Target | Status | Criteria Met |
|------------|--------|--------|--------------|

## Recent Decisions
| Date | Decision | Rationale |
|------|----------|-----------|

## Blockers
{Active blockers or "None"}

## Next Actions
1. {Action}
```

### Phase/Task State Files

Track granular progress within phases and tasks. Same structure, scoped to their level.

## Context Degradation Indicators

Watch for these signs that context needs refresh:

- AI repeats suggestions it already made
- AI contradicts earlier statements
- AI forgets task objectives or constraints
- Responses become vague or generic
- AI references files or APIs that don't exist

## Context Restore Protocol

### Full Restore (new session or major degradation)

1. Load state files (master → phase → task, in that order)
2. Load reference documentation (implementation plan, architecture docs)
3. AI confirms: current state, last completed item, active work, blockers, next actions
4. Verify understanding before taking action

### Quick Refresh (minor confusion)

1. Re-read the relevant state file
2. AI confirms: current step, completed steps, immediate next action

### Emergency Recovery (missing/corrupted state)

1. Read implementation plan
2. Check for any surviving state files
3. Reconstruct state from git history and file timestamps
4. Document reconstructed state in new state file

## Best Practices

- **Update state files after every significant action** — Don't let them go stale
- **Keep state files concise** — They need to fit in context alongside working code
- **Use absolute dates** — "Last Tuesday" becomes meaningless across sessions; use "2026-03-16"
- **Front-load critical context** — Put the most important information first in state files
- **Minimize context window usage** — Read only what's needed for the current task, not everything

## See Also

- [[architecture]] — Orchestrator hierarchy
- [[prompts/context-restore]] — Restore prompt templates
