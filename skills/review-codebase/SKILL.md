---
name: review-codebase
description: Systematic code quality review of a codebase. Use when the user asks to review, audit, or assess code quality — or when a codebase needs security, performance, or architecture analysis.
---

# Systematic Code Review

You are performing a systematic code review, analysing each component for security, software engineering principles, performance, and code quality. Work through the phases below in order.

---

## Reviewer Discipline (read first)

A code review is only useful if its findings are **real**. Five real findings beat twenty findings where five are wrong — false positives erode trust in the accurate findings and waste the team's time chasing ghosts.

Apply these rules before logging any finding.

### 1. Search for the fix before logging the gap

The single biggest source of false positives is "X is missing" when X is actually present somewhere the reviewer didn't look. Before claiming an issue:

- **"No auth on endpoint X"** → grep for `auth`, `token`, `session`, the framework's auth decorator/middleware, the user-resolution function in adjacent files.
- **"No transaction wrapping"** → grep for `Transaction`, `BEGIN`, `commit`, `rollback`, `with db.begin()`.
- **"No validation on input X"** → grep for the field name, the validator library, schema files.
- **"Magic numbers in X"** → grep for the literal value in named constants and config files; the value may already be named.
- **"Missing rate limiting"** → grep for `rate`, `bucket`, `throttle`, `limit`.
- **"Returns `double` where `int` is needed"** → read the actual function signature, don't guess from the name.

If the fix is already present, **don't log the finding**. The review's job is to find real problems, not list features the reviewer expected to be missing.

### 2. Evidence is copy-pasted, never paraphrased

Every code snippet in a finding must be the **actual current contents of the file**, captured via `Read` and quoted verbatim with real line numbers. Never:

- Hand-write a snippet of "what the code probably looks like."
- Reconstruct code from memory or from the file name.
- Paraphrase a function signature, modify it "for clarity," or add ellipses that change its meaning.

If you can't produce a verbatim snippet with a line number, you don't have evidence — drop the finding.

### 3. Assume you're wrong on Critical and High findings

Before logging a Critical or High severity issue, ask: **what evidence would prove this finding is wrong?** Then look for that evidence:

- For "auth missing" — search for the auth gate in adjacent files and in middleware registration.
- For "no transaction" — search the call stack of the function for an outer transaction.
- For "silent failure" — trace the exception path to the consumer.

A Critical finding that turns out to be a false positive is worse than no finding. The bar for Critical/High is high confidence + reproducible evidence.

### 4. CVSS scoring is opt-in, not default

Only assign a CVSS score when:
- The vulnerability is exploitable as described.
- You have traced the attack path end-to-end.
- You're confident a security professional would agree with the score.

A finding without CVSS is fine; a wrong CVSS is not. If unsure, write "Severity: High (no CVSS)" and explain.

### 5. "No notable issues" is a valid component verdict

Not every component must produce findings in every dimension. If a component's security review finds nothing, write "No notable security issues." Don't manufacture findings to fill the section.

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

For each security finding, optionally assign a CVSS score per Reviewer Discipline §4 (only when the vulnerability is exploitable and the attack path traced end-to-end).

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

#### 5. Testability & Refactorability

For every high-priority issue (especially god classes, long methods, and architectural smells), assess whether the code can be safely refactored:

| Check | What to look for |
|-------|-----------------|
| **Test coverage** | Does the class/method have direct test coverage? Count tested vs untested methods. |
| **Mock depth** | Are tests using real objects or do they bypass `__init__` and mock everything? Deep mocking means tests won't catch extraction regressions. |
| **Integration tests** | Are there end-to-end tests that exercise the code path? These are the real safety net. |
| **Coupling to test infrastructure** | Do tests patch private methods (e.g., `@patch.object(Foo, '_private_method')`)? These break when methods move during extraction. |

For each structural issue (god class, long method), add a **Testability** verdict:

- **Safe to refactor** — Direct test coverage exists, regressions will be caught
- **Needs characterization tests first** — Coverage is insufficient, write tests that lock in current behavior before extracting
- **Untestable** — No tests and code is too coupled to mock; refactoring is high-risk without significant test investment

This prevents discovering mid-refactor that you have no safety net — the remediation plan should account for test-writing effort upfront.

#### 6. Performance

- **Database** — N+1 queries, missing indexes, full table scans, unbatched operations
- **Memory** — Large objects in memory, unbounded arrays, missing cleanup
- **I/O** — Synchronous blocking, missing connection pooling, no timeouts
- **Caching** — Frequently-accessed rarely-changed data not cached
- **Concurrency** — Race conditions, missing transactions, thread safety
- **Algorithmic** — O(n²) or worse where O(n) is possible

#### 7. Error Handling

- **Exceptions** — Caught at appropriate levels? Swallowed silently or logged?
- **Error Messages** — Do responses leak internals (stack traces, paths, SQL)?
- **Recovery** — Retry mechanisms for external service calls?
- **Validation Errors** — Reported clearly to caller?

#### 8. Language-Specific

**Python:** Circular references, generator opportunities missed, large objects held unnecessarily
**JavaScript/TypeScript:** Event listener leaks, closure memory leaks, async/await anti-patterns
**General:** Resource cleanup (file handles, connections), context managers

#### 9. Incomplete Features

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

> [!IMPORTANT]
> Score each dimension based on what you **actually found**, not on a target distribution. A component with no security issues scores 9-10 on Security — it does not score 6 because "every component must have something." Per Reviewer Discipline §5, "no notable issues" is a valid finding for any dimension. Do not invent issues to justify a lower score.

### Component Review Document

Each review produces `components/NN-component-name.md` containing:

- Score with visual bar and weighted breakdown
- File inventory with line counts
- Architecture diagram (Mermaid)
- Security findings with evidence, impact, optional CVSS, and remediation code
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

- **Component link**, **file:line**, **severity**
- **CVSS** — only when the criteria in Reviewer Discipline §4 are met; otherwise omit
- **Description** — What and why it matters
- **Evidence** — Verbatim code from the file at the cited line numbers, captured via `Read`. No paraphrasing, no reconstructed snippets. (Reviewer Discipline §2)
- **Impact** — Specific consequences
- **Remediation** — Concrete working code, not vague advice
- **Testability** (for HIGH+ structural issues) — Safe to refactor / Needs characterization tests / Untestable
- **Counter-evidence searched** (for CRIT and HIGH) — One line stating what you grepped/read to confirm the issue is real and the fix is not already in place. (Reviewer Discipline §1, §3)

Before logging, apply Reviewer Discipline §1 (search for the fix) and §3 (assume you're wrong on Critical/High). If the search turns up the fix, drop the finding instead of logging it.

---

## Phase 3.5: Verification Pass

After all component reviews are complete and before Phase 4, do one verification pass over every issue logged so far. This is the gate that catches false positives before they reach the executive summary.

### Re-read every Critical and High finding

For each `CRIT-*` and `HIGH-*` issue:

1. Re-read the cited file(s) at the cited line(s) using `Read`.
2. Confirm the verbatim snippet in the issue matches the file's current contents exactly. If it doesn't (the file has changed, or the snippet was paraphrased), either correct it or drop the finding.
3. Confirm the claimed problem is still present. If the recommended fix is already in the code, drop the finding.
4. Re-run the §1 grep — search the wider codebase for the fix you claimed was missing. If you find it, drop the finding.

A dropped finding is a win, not a loss. It means the review is more accurate.

### Consolidate duplicates

Walk all four `issues/*.md` files and look for the same finding logged at multiple severities (e.g., the same pricing bug appearing as both HIGH-003 and MED-009, or the same JSON schema gap as both HIGH-005 and MED-002).

For each duplicate pair: keep the higher-severity entry, replace the lower-severity entry with a one-line `**Duplicate of HIGH-NNN.** See above.` pointer. Do not delete the lower entry — preserving the ID keeps cross-references stable.

### Sanity check the headline numbers

Before writing the executive summary:

- Total findings count — is it inflated by duplicates or speculative items?
- Critical/High count — would you stake your reputation on each one being real and exploitable?
- Component scores — do any feel forced (a low score driven by manufactured findings)? Adjust upward if so.

If the verification pass cuts the finding count substantially, that's expected and good. The original count was a draft, not a target.

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
- [ ] Phase 3.5 verification pass run; every Critical and High finding re-read against the live file
- [ ] Duplicates consolidated; no two issue IDs cover the same finding
- [ ] Every CRIT/HIGH finding has a "Counter-evidence searched" line proving the fix isn't already in place
- [ ] Every code snippet in every finding is verbatim from the file (no paraphrasing or fabrication)
- [ ] CVSS scores assigned only where the §4 criteria are met
- [ ] Integration analysis covers data flows between all major components
- [ ] Quick wins are identified and actionable with code
- [ ] Refactoring plan has sprint-level detail
- [ ] Executive summary provides clear next steps for decision-makers
