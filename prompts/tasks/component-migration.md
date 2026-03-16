# Component Migration Task Prompt

> [!NOTE]
> Use when migrating a component to use shared packages or a new architecture.

---

## Prompt Template

```
# Task: Migrate {COMPONENT_NAME} to Use Shared Packages

You are migrating {COMPONENT_NAME} from {CODEBASE} to use shared packages.

## Task Overview

- Component: {COMPONENT_NAME}
- Source: {SOURCE_FILE_PATH}
- Target: Same location, updated imports
- Packages to use: {LIST_PACKAGES}

## Objective

Update {COMPONENT_NAME} to import from shared packages instead of local implementations, preserving all existing functionality.

## Context

Please read:
1. Component review: {PATH_TO_REVIEW}/components/{COMPONENT}.md
2. Package API documentation for each package being used
3. Integration test patterns

## Migration Steps

1. **Update Imports** — Replace local imports with package imports
2. **Adapt to Package API** — Adjust function calls to match package interface
3. **Update Types** — Use types from packages, remove duplicate definitions
4. **Test** — Run existing tests, add integration tests for package usage
5. **Clean Up** — Remove deprecated local code, update documentation

## Acceptance Criteria

- [ ] All imports updated to use packages
- [ ] No duplicate code with packages
- [ ] Type checks pass
- [ ] All existing tests pass
- [ ] No runtime regressions
- [ ] No `any` types introduced
- [ ] Error handling preserved
- [ ] Documentation updated
```

## Common Migration Patterns

### Auth Migration

```typescript
// Before
import { authenticateToken } from '../middleware/auth'
import { generateToken } from '../utils/jwt'

// After
import { authenticateToken, generateToken } from '@project/auth'
```

### Database Migration

```typescript
// Before
import pool from '../utils/database'

// After
import { createPool, query } from '@project/db'
```

### UI Component Migration

```typescript
// Before
import VideoPlayer from '../components/VideoPlayer'

// After
import { VideoPlayer } from '@project/ui'
```

## See Also

- [[package-extraction]] — Creating the packages being consumed
- [[test-generation]] — Adding tests for migrated code
- [[../quality-gates]] — Migration quality criteria
