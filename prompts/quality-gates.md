---
title: Quality Gates and Checkpoints
created: 2026-03-16
updated: 2026-03-16
status: active
tags: [quality, gates, checkpoints, validation]
---

# Quality Gates and Checkpoints

## Overview

Quality gates are mandatory checkpoints requiring validation before proceeding to the next phase. Define these based on your implementation plan.

## Defining Checkpoints

Each checkpoint needs:

| Field | Description |
|-------|-------------|
| ID | Short identifier (CP-1, CP-2, ...) |
| Phase | Which phase it gates |
| Criteria | Specific, measurable pass/fail conditions |
| Measurement | How to verify each criterion |
| Human Review | Whether human sign-off is required |

### Example Checkpoint

| Criterion | Measurement | Pass Threshold |
|-----------|-------------|----------------|
| Critical vulnerabilities | Security scan | 0 remaining |
| Credential exposure | Grep source for secrets | 0 matches |
| Test coverage | Coverage report | >80% |
| Build | CI pipeline | Passes |

## Task-Level Quality Gates

### Security Fix

- [ ] Vulnerability resolved
- [ ] No credentials in code or logs
- [ ] Input validation implemented
- [ ] Error messages don't leak internals
- [ ] Tests verify the fix
- [ ] Secure defaults used

### Package Extraction

- [ ] Package builds without errors
- [ ] All tests pass with target coverage
- [ ] No circular dependencies
- [ ] API documentation complete
- [ ] Can be imported by a consumer app

### Component Migration

- [ ] All imports updated to use shared packages
- [ ] No duplicate code with packages
- [ ] TypeScript/type checks pass
- [ ] All existing tests pass
- [ ] No runtime regressions

### Test Generation

- [ ] Coverage meets target
- [ ] All edge cases from code review covered
- [ ] Tests are deterministic and isolated
- [ ] Clear test descriptions

## Automated Checks

| Check | Example Command | Pass Criteria |
|-------|-----------------|---------------|
| Type check | `npm run typecheck` | No errors |
| Lint | `npm run lint` | No errors |
| Tests | `npm test` | All pass |
| Coverage | `npm test --coverage` | Meets target |
| Build | `npm run build` | Succeeds |

## Coverage Targets

| Component Type | Target |
|---------------|--------|
| Auth / Security | 90% |
| Business Logic | 80% |
| UI Components | 70% |
| Utilities | 85% |

## Human Review Triggers

| Trigger | Reviewer |
|---------|----------|
| Security changes | Security lead |
| API design changes | Tech lead |
| Database schema changes | DBA |
| Production deployment | Product owner |
| Architecture decisions | Architect |

## Rollback Procedures

Every change should have a documented rollback:

- **Package rollback** — Revert to previous version, redeploy consumers
- **Migration rollback** — Revert PR, redeploy previous version
- **Database rollback** — Reverse migration script

## Definition of Done

### Task Level

- All acceptance criteria met
- All automated checks pass
- State file updated
- Parent orchestrator notified

### Phase Level

- All tasks complete
- Exit criteria met
- Checkpoint passed
- Documentation updated

## See Also

- [[README]] — Playbook overview
- [[architecture]] — Orchestrator structure
- [[docs-protocol]] — Documentation requirements
