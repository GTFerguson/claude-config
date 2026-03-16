# Test Generation Task Prompt

Use this prompt when generating tests for a component.

## Prompt Template

```
# Task: Generate Tests for {COMPONENT_NAME}

You are writing tests for {COMPONENT_NAME} to achieve {TARGET_COVERAGE} coverage.

## Component Details

- Component: {COMPONENT_NAME}
- Location: {FILE_PATH}
- Test Location: {TEST_FILE_PATH}
- Coverage Target: {TARGET_COVERAGE}

## Context

Please read:
1. Component implementation file
2. Code review for edge cases: {PATH_TO_REVIEW}/components/{COMPONENT}.md
3. Related issues: {PATH_TO_ISSUES}/

## Test Categories

### Unit Tests
- Test each public function in isolation
- Mock dependencies
- Cover happy path and error cases

### Edge Cases from Code Review
- Cover every edge case identified in the code review
- Pay special attention to error paths and boundary conditions

### Integration Tests
- Test component interaction with real dependencies
- Use realistic data

## Test Structure

- describe block for component
- Nested describe for each function
- it blocks for each test case
- beforeEach for setup, afterEach for cleanup

## Acceptance Criteria

- [ ] Coverage meets {TARGET_COVERAGE}
- [ ] All edge cases from code review covered
- [ ] Tests are deterministic
- [ ] Tests run in isolation (no shared state)
- [ ] Clear, descriptive test names
```

## Coverage Targets

| Component Type | Target |
|---------------|--------|
| Auth / Security | 90% |
| Business Logic | 80% |
| UI Components | 70% |
| Utilities | 85% |

## See Also

- [[component-migration]] — Migration tasks
- [[../quality-gates]] — Test requirements
