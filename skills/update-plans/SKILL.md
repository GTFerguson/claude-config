---
name: update-plans
description: Audit plan docs — verify shipped phases against code, stub completed phases in-place, log quality issues, and delete plans only when the whole scope has shipped. Use when plans may be stale or after a batch of features ships.
---

# Update Plans

Audit plan docs in the project. Verify claimed progress against the actual code, **stub completed phases inside the plan**, keep the plan alive as the home for remaining work, and only delete when the entire scope has shipped.

If `$ARGUMENTS` is a path to a specific plan file, process only that file. Otherwise, scan `docs/plans/` (or the project's equivalent plans directory).

## Core model — read this first

`docs/architecture/` (or `technical/`, `design/`, etc.) and `docs/plans/` are **separate and stay separate**:

- **Architecture docs** = what is shipped and how it works.
- **Plans** = what is planned, in-progress, and future.

Completed plan content does **not** graduate into architecture docs by default — it **stubs in-place within the plan**. The stub is a compressed record of what shipped, keeping just the details that help execute the remaining phases (key decisions, file/module locations, integration points, gotchas). The itemized phase body is trimmed so the plan body stays focused on what's left.

Key distinctions to internalise:

- **"Phase 1d complete, Phase 2 remains"** is the correct state for an *active* plan. Do NOT flag it for deletion — stub 1d and move on.
- **Stub, don't graduate.** Completed phase content stays in the plan as a compact summary. Only surface a separate architecture doc to the user when something is genuinely novel enough to deserve one — don't do it silently.
- **Roadmap-style docs persist.** A plan named `roadmap.md` or one that clearly serves as a long-horizon vision index shrinks its completed phase sections to summaries, but is not stubbed or deleted.
- **Delete a plan only when** its entire scope has shipped AND no future work is referenced AND no knowledge needs preserving.
- **Verify against actual code**, not against orchestrators or knowledge-graph tools that may be stale or unavailable.

## Step 1: Discover project structure

Identify:
- Where plan docs live (typically `docs/plans/`; may be nested).
- What sibling doc directories exist under `docs/` (could be `architecture/`, `technical/`, `design/`, `adr/`, `reference/`, `guides/`, etc.) — for context only, not as a default graduation target.
- Whether `docs/plans/quick-fixes/` exists; if not, you may create it in Step 4 for any quality issues found during verification.
- Read CLAUDE.md or similar project instructions for doc conventions.

## Step 2: Spawn per-plan agents

For each plan file, launch an agent (in parallel where possible) with this brief:

> **Your task**: Audit the plan doc at `{path}`. Research only — do NOT edit anything.
>
> 1. **Read the plan** fully. Identify each phase/slice and what it claims is complete vs in-progress vs future.
>
> 2. **Verify each claimed-shipped phase against the actual code.** Read source files directly — do not rely on orchestrators or knowledge-graph tools that may be stale or unavailable. For each item the plan says has shipped:
>    - Confirm the modules, functions, tables, endpoints, tests, UI, etc. actually exist and behave as described.
>    - Capture the key file paths that implement it.
>    - If a claimed-shipped item is **not** in the code, treat it as incomplete.
>
> 3. **Classify the plan's overall state**:
>    - **Fully shipped** — every phase is implemented and no future phases are referenced.
>    - **Partially shipped** — one or more phases complete; others remain. Common case.
>    - **Not started / early** — nothing fully complete yet.
>    - **Roadmap-style** — long-horizon vision index meant to persist (e.g. `roadmap.md`).
>
> 4. **Draft a stub for each fully-shipped phase.** The stub should be compact but preserve what helps execute the remaining phases:
>    - One-sentence summary of what shipped.
>    - Key file paths / modules.
>    - Non-obvious design decisions or integration points worth remembering.
>    - Known gotchas or constraints the remaining work must respect.
>    Exclude itemized task lists, dated progress notes, and blow-by-blow history — the stub is a compressed record, not an archive.
>
> 5. **Log any quality issues** you hit while verifying shipped code. Do NOT fix them. For each, capture:
>    - Category: logic bug / performance / missing cross-system hook / technical debt blocking future phases.
>    - Specific problem description (not vague).
>    - Evidence: file paths with line numbers, observed behavior.
>    - Why it matters: what breaks or what is blocked.
>    - Suggested fix direction (not implementation detail).
>
> 6. **Return a structured report**:
>    - Plan classification (step 3).
>    - Current frontmatter `status` vs recommended `status`.
>    - Per-phase verification result with evidence (file paths).
>    - Stub content for each fully-shipped phase (ready for Step 4 to use).
>    - Quality issues formatted for `docs/plans/quick-fixes/` entries.
>    - Recommended action: `stub-phases` | `update-status-only` | `roadmap-shrink` | `delete` | `leave-as-is`.
>    - Verification date (today).
>
> Do NOT edit any files. Research only.

## Step 3: Review agent results

Collect all agent reports. Look for:
- **Status corrections** — plans whose frontmatter lies about their state.
- **Phases to stub** — completed slices within partially-shipped plans.
- **Cross-cutting issues** — quality problems that span multiple plans.
- **Rare graduation candidates** — anything so novel it might warrant a standalone architecture doc. Surface these to the user as suggestions, not defaults.

Present findings to the user before making changes:

```
Plan Audit — verified {YYYY-MM-DD}

{plan-path}
  Classification: {fully-shipped | partially-shipped | in-progress | roadmap}
  Status: {current} → {recommended}
  Action: {stub-phases | update-status-only | roadmap-shrink | delete | leave-as-is}
  Phases to stub: {list, or "none"}
  Remaining work: {list, or "none"}
  Quality issues: {count}

...

Ready to delete (entire scope shipped, nothing referenced):
  {plan-path}

Quality issues to file under docs/plans/quick-fixes/:
  {title} — {priority} — {one-line problem}
```

Ask the user to confirm before proceeding with edits.

## Step 4: Execute changes

For each item the user approved:

### 4a. Stub completed phases in-place (the common case)

For each fully-shipped phase in a partially-shipped plan:

1. Add or extend a **"Completed Phases"** section near the top of the plan (below the frontmatter and any intro). Each entry:

   ```markdown
   ### Phase {X} — {name} — Completed {YYYY-MM-DD}

   {One-paragraph summary of what shipped.}

   Key code: `{path/to/file.ext}`, `{path/to/other.ext}`

   {Optional: non-obvious decisions, integration points, or gotchas that
   future phases must respect.}
   ```

2. **Trim the phase's itemized detail from the plan body.** The stub replaces it. Keep only what helps execute the remaining phases — remove task lists, progress notes, and blow-by-blow history.

3. Update frontmatter: add/refresh a `verified: YYYY-MM-DD` field, and adjust `status` if it changed.

### 4b. Status-only updates

Plans where the frontmatter `status` is wrong but no stubbing is needed (e.g. a `draft` plan that's now `active`): update frontmatter only.

### 4c. Roadmap shrink

Roadmap-style docs (vision indexes meant to persist): shrink completed phase sections to a one-line summary linking to the relevant code or architecture doc. Do not stub-then-delete; roadmaps stay.

### 4d. Delete completed plans

Delete a plan file only when **all** of:
- Every phase has shipped (verified against code).
- No remaining or future work is referenced.
- No knowledge inside needs preserving elsewhere (if it does, surface to the user first — do not silently graduate it).

### 4e. File quality issues under `docs/plans/quick-fixes/`

Create `docs/plans/quick-fixes/` if it doesn't exist. For each issue, create `{slug}.md`:

```markdown
---
title: {short descriptive title}
created: {YYYY-MM-DD}
status: active
priority: {high | medium | low}
---

## Problem

{Specific description — not vague.}

## Evidence

- `{file}:{line}` — {observed behavior}

## Why it matters

{What breaks; what future work this blocks.}

## Suggested fix direction

{Direction, not implementation detail.}
```

Do **not** fix these issues inline during this skill run. The quick-fix docs are the handoff.

## Step 5: Summary

```
Verified: {YYYY-MM-DD}

Phases stubbed:
  {plan} — {phase names}

Statuses updated:
  {plan}: {old} → {new}

Roadmaps shrunk:
  {plan} — {phases summarised}

Plans deleted:
  {plan} — entire scope shipped

Plans retained as-is:
  {plan} — {reason: in-progress / roadmap / user declined}

Quality issues logged:
  docs/plans/quick-fixes/{slug}.md — {priority} — {title}
```
