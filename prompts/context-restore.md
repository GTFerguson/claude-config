# Context Restore Prompt

Use this prompt to restore context when starting a new session or when context has degraded.

## Full Context Restore

```
# Context Restoration Request

I need to restore context for this implementation project.

## Session Information

- Previous Role: {Master Orchestrator / Phase Orchestrator / Task Orchestrator}
- Previous Phase: {PHASE_NUMBER} {PHASE_NAME}
- Previous Task: {TASK_NAME} (if applicable)

## Please Load These Documents

### State Files — Load First
1. {PATH_TO_PROGRESS}/master-state.md
2. {PATH_TO_PROGRESS}/{PHASE_STATE_FILE} (if applicable)
3. {PATH_TO_PROGRESS}/{TASK_STATE_FILE} (if applicable)

### Reference Documentation
4. {PATH_TO_PLAYBOOK}/architecture.md
5. {PATH_TO_IMPLEMENTATION_PLAN}

## After Loading, Please Confirm

1. **Current State** — What phase, what percentage, last completed item?
2. **Active Work** — What was in progress? Any incomplete tasks?
3. **Blockers** — Any documented blockers or pending decisions?
4. **Next Actions** — What should we work on next? Anything urgent?

## Resume Protocol

1. Update state files if timestamps are stale
2. Verify understanding before taking action
3. Ask clarifying questions if anything is unclear
4. Proceed with next documented action
```

## Quick Context Refresh

For minor context issues:

```
# Quick Context Refresh

Current task: {TASK_NAME}
State file: {PATH_TO_STATE_FILE}

Please re-read the state file and confirm:
- Current step in progress
- Completed steps
- Immediate next action
```

## Emergency Recovery

If state files are missing or corrupted:

```
# Emergency Context Recovery

State files appear corrupted or missing. Please:

1. Read the implementation plan: {PATH_TO_PLAN}
2. Check for any state files: {PATH_TO_PROGRESS}/
3. Reconstruct current state from:
   - Git history of recent changes
   - File modification timestamps
   - Any partial state information
4. Document reconstructed state in a new state file
```

## When to Use Each

| Situation | Prompt |
|-----------|--------|
| New session after break | Full Restore |
| Minor confusion | Quick Refresh |
| Lost state files | Emergency Recovery |
| Switching between tasks | Full Restore |
| AI contradicting itself or going vague | Full Restore |

## Context Degradation Indicators

- AI repeats previous suggestions
- AI contradicts earlier statements
- AI forgets task objectives
- Responses become vague or generic
- AI references files or APIs that don't exist

## See Also

- [[../context-management]] — Full context management guide
- [[master-orchestrator-init]] — Start fresh master session
- [[phase-orchestrator-init]] — Start fresh phase session
