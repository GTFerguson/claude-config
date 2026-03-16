# Package Extraction Task Prompt

Use this prompt when extracting shared code into a reusable package.

## Prompt Template

```
# Task: Extract {PACKAGE_NAME} Package

You are extracting {PACKAGE_NAME} from the existing codebase into a standalone, reusable package.

## Task Overview

- Package: {PACKAGE_NAME}
- Source: {SOURCE_CODEBASE} — {SOURCE_FILES}
- Target: packages/{PACKAGE_NAME}/

## Objective

Extract {DESCRIPTION} into a standalone, reusable package that can be shared across applications.

## Context

Please read:
1. Architecture proposal: {PATH_TO_PROPOSAL}#{RELEVANT_SECTION}
2. Component review: {PATH_TO_REVIEW}/{COMPONENT}.md
3. Task state file (if exists)

## Target Package Structure

packages/{PACKAGE_NAME}/
├── src/
│   ├── [modules]
│   └── index.ts
├── tests/
├── package.json
├── tsconfig.json
└── README.md

## Subtasks

1. **Design** — Define public API surface, type definitions, internal structure
2. **Scaffold** — Create directory structure, package.json, config
3. **Implement** — Migrate core functionality, add types, add error handling
4. **Test** — Unit tests (80%+ coverage), integration tests, edge cases
5. **Document** — API documentation, usage examples, migration guide

## Acceptance Criteria

- [ ] Package builds without errors
- [ ] All tests pass with 80%+ coverage
- [ ] No circular dependencies
- [ ] API documentation complete
- [ ] Can be imported by a test consumer
- [ ] No `any` types except where justified
```

## See Also

- [[phase-orchestrator-init]] — Parent phase orchestrator
- [[../architecture]] — Task decomposition rules
- [[../quality-gates]] — Package extraction criteria
