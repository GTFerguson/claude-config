---
name: review-codebase
description: Systematic code quality review of a codebase. Use when the user asks to review, audit, or assess code quality — or when a codebase needs security, performance, or architecture analysis.
---

# Systematic Code Review

You are performing a systematic code review, analysing each component for security, software engineering principles, performance, and code quality. Work through the phases below in order.

---

## Phase 1: Discovery

Investigate the codebase to understand its shape before diving into reviews.

### 1. Documentation Review

- Read any `docs/` folder, README files, architecture docs
- Identify known issues or blocking problems already documented
- Understand design patterns already in use

### 2. Codebase Structure Analysis

- Map directory structure and identify major subsystems/components
- Note file sizes (files >500 lines likely have issues)
- Identify interfaces, abstract classes, and inheritance hierarchies
- Count test files and assess coverage

### 3. Create Dynamic Analysis Plan

Produce `00-analysis-plan.md` containing:

- **Component inventory** — Every distinct component with: number, name, location, file count, approximate LOC, priority (Critical/High/Medium/Low), and review focus areas
- **Priority criteria**: Critical = auth, database, core APIs (security breach/data loss risk); High = business logic, AI/ML, external integrations; Medium = admin, frontend clients, config; Low = scripts, static pages, types
- **Review phases** — Components grouped into 4 phases by priority and dependency order
- **Dependency map** — Mermaid diagram showing component dependencies
- **Known risks** — Issues spotted during discovery with file:line evidence
- **File-to-review mapping** — For each component, list every file with line count and focus areas

---

## Phase 2: Output Structure

All review output goes into a structured directory:

```
code-review/{project}/
├── README.md                    # Navigation index with scores and links
├── 00-analysis-plan.md          # From Phase 1
├── 00-executive-summary.md      # From Phase 6
├── components/
│   └── NN-component-name.md     # One per component (Phase 3)
├── integration/
│   ├── data-flow-analysis.md    # Phase 4
│   ├── dependency-graph.md      # Phase 4
│   └── coupling-assessment.md   # Phase 4
├── issues/
│   ├── critical.md              # Accumulated across components
│   ├── high-priority.md
│   ├── medium-priority.md
│   └── low-priority.md
└── recommendations/
    ├── quick-wins.md            # <4 hour fixes
    ├── refactoring-plan.md      # Multi-sprint roadmap
    └── architecture-improvements.md
```

---

## Phase 3: Component Reviews

For each component in the analysis plan, perform the full review below. Work through phases in order (Critical Security → Business Logic → Supporting → Frontend).

### Review Dimensions

#### 1. Security Review

For every file in the component:

- **Authentication** — Are all endpoints that need auth actually protected? Is the auth check correct and not bypassable?
- **Authorization** — Does the code verify the user has permission for the specific resource? Check for IDOR.
- **Input Validation** — Is all user input validated? Check for SQL injection, command injection, path traversal, XSS.
- **Sensitive Data** — Are secrets, API keys, passwords, or PII logged, exposed in errors, or hardcoded?
- **Cryptography** — Are hashing algorithms current (bcrypt/argon2, not MD5/SHA1)? JWT secrets strong? SSL/TLS correct?
- **Rate Limiting** — Are expensive or sensitive operations rate-limited?
- **CSRF/CORS** — Is cross-origin protection configured correctly?
- **Fail Mode** — Does code fail open (dangerous) or fail closed (safe)?

For each security finding, estimate a CVSS score.

#### 2. SOLID Principles

| Principle | Check |
|-----------|-------|
| **S**ingle Responsibility | Does each class/file have one reason to change? Flag files >300 lines, functions >50 lines |
| **O**pen/Closed | Can behaviour be extended without modifying existing code? |
| **L**iskov Substitution | Can subtypes substitute base types safely? |
| **I**nterface Segregation | Are interfaces small and focused? |
| **D**ependency Inversion | Do high-level modules depend on abstractions? |

#### 3. Code Quality

- **Naming** — Descriptive, consistent, matches actual behaviour
- **DRY** — Duplicated logic that should be extracted
- **Dead Code** — Unused imports, unreachable branches, commented-out blocks
- **Type Safety** — Use of `any`, missing annotations, unsafe type assertions
- **Magic Numbers** — Hardcoded values without explanation

#### 4. Code Smells

| Smell | Threshold |
|-------|-----------|
| God Class/File | >500 lines |
| Long Method | >50 lines |
| Feature Envy | Method using other classes' data excessively |
| Data Clumps | Groups of data appearing together repeatedly |
| Primitive Obsession | Overuse of primitives vs small objects |
| Shotgun Surgery | Change requires many small edits across files |
| Dead Code | Unused methods, variables, parameters |

#### 5. Performance

- **Database** — N+1 queries, missing indexes, full table scans, unbatched operations
- **Memory** — Large objects in memory, unbounded arrays, missing cleanup
- **I/O** — Synchronous blocking, missing connection pooling, no timeouts
- **Caching** — Frequently-accessed rarely-changed data not cached
- **Concurrency** — Race conditions, missing transactions, thread safety
- **Algorithmic** — O(n²) or worse where O(n) is possible

#### 6. Error Handling

- **Exceptions** — Caught at appropriate levels? Swallowed silently or logged?
- **Error Messages** — Do responses leak internals (stack traces, paths, SQL)?
- **Recovery** — Retry mechanisms for external service calls?
- **Validation Errors** — Reported clearly to caller?

#### 7. Language-Specific

**Python:** Circular references, generator opportunities missed, large objects held unnecessarily
**JavaScript/TypeScript:** Event listener leaks, closure memory leaks, async/await anti-patterns
**General:** Resource cleanup (file handles, connections), context managers

#### 8. Incomplete Features

- TODO comments indicating unfinished work
- Stub methods returning defaults
- Deprecated methods still in use
- Feature flags or conditional code paths

### Scoring

Score each component 1-10:

| Range | Label | Criteria |
|-------|-------|----------|
| 8-10 | Good | No critical/high issues, well-structured, tests present |
| 6-7.9 | Average | No critical issues, some high, reasonable structure |
| 4-5.9 | Poor | Critical or multiple high issues, structural problems, no tests |
| 1-3.9 | Critical | Multiple critical issues, fundamental design flaws, actively dangerous |

Weighted breakdown:

| Dimension | Weight |
|-----------|--------|
| Security | 35% |
| Code Quality (SOLID + Smells) | 25% |
| Performance | 20% |
| Error Handling | 20% |

### Component Review Document

Each review produces `components/NN-component-name.md` containing:

- Score with visual bar and weighted breakdown
- File inventory with line counts
- Architecture diagram (Mermaid)
- Security findings with evidence, impact, CVSS, and remediation code
- SOLID analysis with status and evidence per principle
- Code smells table (smell, location, description, suggested fix)
- DRY violations table (pattern, occurrences, suggested refactoring)
- Performance concerns table (concern, location, impact, recommendation)
- Error handling assessment
- Incomplete features list
- Recommendations (immediate / short-term / long-term)

### Issue Logging

Log every issue to `issues/{severity}.md` as you review. Use global sequential IDs:

- `CRIT-001`, `CRIT-002`, ... — Security vulnerabilities, data exposure, system integrity
- `HIGH-001`, `HIGH-002`, ... — Reliability failures, business logic bugs
- `MED-001`, `MED-002`, ... — Code quality, maintainability
- `LOW-001`, `LOW-002`, ... — Style, minor improvements

Each issue entry must include:

- **Component link**, **file:line**, **severity**, **CVSS** (for security)
- **Description** — What and why it matters
- **Evidence** — The actual problematic code with path and line numbers
- **Impact** — Specific consequences
- **Remediation** — Concrete working code, not vague advice

---

## Phase 4: Integration Analysis

After component reviews, analyse cross-cutting concerns.

### Data Flow Analysis

For each major user-facing operation, trace the complete data path:

1. **Entry point** — Where data enters (user input, webhook, cron)
2. **Transformation points** — Every place data changes format, is validated, parsed, or enriched (file:line for each)
3. **Security checkpoints** — Every auth/validation check: present ✅, weak ⚠️, or missing ❌
4. **Storage points** — Where data is persisted
5. **Exit points** — Where data leaves (response, email, webhook, export)
6. **Bottlenecks** — Points where performance degrades under load

Document with Mermaid sequence diagrams (request/response) and flowcharts (processing pipelines).

### Dependency Graph

- Map module-level imports across the codebase
- Identify circular dependencies, layer violations, god modules, orphan modules
- Document as Mermaid flowchart with components grouped by architectural layer

### Coupling Assessment

Check for: data coupling, temporal coupling, control coupling, platform coupling, content coupling. For each finding: which components, what type, severity, what breaks, decoupling strategy.

---

## Phase 5: Recommendations

### Quick Wins (`recommendations/quick-wins.md`)

For each quick win (<4 hours effort):
- Link to the issue it addresses
- Impact assessment
- Before/after code
- Effort estimate
- Implementation checklist ordered by priority (do today → this week → this sprint)

### Refactoring Plan (`recommendations/refactoring-plan.md`)

Multi-sprint roadmap with:
- Gantt chart (Mermaid)
- Per-sprint: tasks, target score, duration, issues resolved
- Score progression table
- Resource requirements
- Risks and mitigations

### Architecture Improvements (`recommendations/architecture-improvements.md`)

Long-term structural changes:
- Current vs proposed state (with Mermaid diagrams)
- Benefits, migration path, risks
- Priority matrix (impact × effort)
- Implementation order respecting dependencies

---

## Phase 6: Synthesis

### Executive Summary (`00-executive-summary.md`)

- **Health score** with visual bar
- **Key findings** by category (Security, Architecture, Code Quality)
- **Risk assessment** matrix (area, risk level, impact, notes)
- **Action priorities** tiered: Today → This Week → This Sprint
- **Roadmap** (Mermaid Gantt) with score progression milestones
- **Investment summary** (effort, resources, issues resolved, score impact)
- **Business impact** (current risk exposure, expected ROI)

### Navigation Index (`README.md`)

- Health score with visual bar
- Quick links to executive summary, critical issues, quick wins
- Component review table (number, name, score, critical issue count, link)
- Issue tracking table (severity, count, link)
- Recommendation table (document, scope, effort)
- Roadmap overview (Mermaid Gantt)

---

## Document Conventions

- **Frontmatter**: YAML with title, created, updated, status, tags on every document
- **Tables**: Always have a blank line above them
- **Callouts**: `> [!CRITICAL]`, `> [!WARNING]`, `> [!TIP]`, `> [!NOTE]`, `> [!IMPORTANT]`
- **Diagrams**: Mermaid for data flows, dependency graphs, timelines
- **Cross-references**: `[[path/to/doc]]` wiki-links
- **Issue IDs**: `CRIT-001`, `HIGH-001`, `MED-001`, `LOW-001`
- **Code evidence**: Always include file path and line number

## Completion Criteria

- [ ] All components have individual review documents with scores
- [ ] All issues categorised by severity with evidence and remediation code
- [ ] Integration analysis covers data flows between all major components
- [ ] Quick wins are identified and actionable with code
- [ ] Refactoring plan has sprint-level detail
- [ ] Executive summary provides clear next steps for decision-makers
- [ ] Every finding cites specific file:line evidence
- [ ] No false positives — every issue is real and reproducible
