---
name: update-plans
description: Audit plan docs — verify statuses against implementation, document completed work, delete finished plans. Use when plans may be stale or after a batch of features ships.
---

# Update Plans

Audit all plan docs in the project, verify their statuses against actual implementation, ensure completed work is properly documented, and delete finished plans.

If `$ARGUMENTS` is a path to a specific plan file, process only that file. Otherwise, scan `docs/plans/` (or the project's equivalent plans directory).

## Step 1: Discover project structure

Identify:
- Where plan docs live (typically `docs/plans/`)
- Where documentation lives — don't assume directory names. Check what exists under `docs/` (could be `architecture/`, `technical/`, `design/`, `adr/`, `reference/`, `guides/`, etc.)
- Read CLAUDE.md or similar project instructions for doc conventions

## Step 2: Spawn per-plan agents

For each plan file, launch an agent (in parallel where possible) with this brief:

> **Your task**: Audit the plan doc at `{path}`.
>
> 1. **Read the plan** fully. Understand what it describes — features, design decisions, algorithms, domain rationale.
>
> 2. **Verify status against reality**. Check the actual codebase:
>    - Do the modules, tables, API endpoints, tests described in the plan exist?
>    - Is the feature partially or fully shipped?
>    - Compare the plan's frontmatter `status` to what you find.
>
> 3. **Report your assessment**:
>    - If the status is **wrong**, state what it should be and why.
>    - If the plan is **not fully complete**, report what's done vs remaining. Stop here.
>    - If the plan is **fully complete**, continue to step 4.
>
> 4. **Check documentation coverage**. The project's doc directories are: `{list of doc dirs}`.
>    - Search existing docs for content that covers what this plan describes.
>    - Identify gaps — design decisions, architecture, domain knowledge in the plan that aren't captured in any existing doc.
>
> 5. **Return your findings**:
>    - Status assessment (current vs recommended)
>    - Whether the plan is fully complete
>    - Which existing docs cover the plan's content (with file paths)
>    - What gaps exist (knowledge in the plan not documented elsewhere)
>    - Recommended action: update status / create docs / extend existing docs / delete plan
>
> Do NOT make any edits. Research only.

## Step 3: Review agent results

Collect all agent reports. Look for:
- **Conflicts**: Two plans that should feed into the same doc — sequence those updates
- **Status corrections**: Plans that aren't complete but have wrong statuses
- **Cross-cutting concerns**: Knowledge that spans multiple plans and should be a single doc

Present findings to the user before making changes:

```
Plan Status Audit:
  {plan}: {current status} → {recommended status} — {reason}
  ...

Ready to delete (fully complete + documented):
  {plan} — covered by {doc1}, {doc2}

Needs documentation first:
  {plan} — gaps: {description of missing knowledge}
  → will create/extend: {target doc path}
```

Ask the user to confirm before proceeding with edits.

## Step 4: Execute changes

For plans the user approved:

1. **Status-only updates**: Fix frontmatter `status` on plans that aren't complete but have wrong statuses.

2. **Documentation gaps**: Create or extend docs to capture missing knowledge from completed plans.
   - Prefer extending existing docs over creating new ones
   - Follow the project's doc conventions (frontmatter, formatting, structure)
   - Architecture docs: describe how the system works + decision rationale
   - Reference docs: domain knowledge with citations (follow PROVEN principles if the project uses them)

3. **Delete completed plans**: Delete plan files that are fully complete AND fully documented (either already or after step 2).

## Step 5: Summary

```
Updated statuses:
  {plan}: {old} → {new}

Docs created/updated:
  {doc path} — {what was added}

Plans deleted:
  {plan} — knowledge preserved in {doc1}, {doc2}

Plans retained:
  {plan} — {reason (incomplete / user declined)}
```
