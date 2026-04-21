---
name: focus
description: Assess and organise docs for a specific topic (e.g. "narrative quests", "combat", "economy"), cluster loose reference files, surface the current phase status, and give an exec overview so dev work can begin. Use when starting a session on a topic area.
---

# Focus

Given a topic, scan the project's docs, assess what exists, tidy loose files into clusters, and present a clear picture of what's shipped, what's next, and the work breakdown. Ends with an overview the user can build on or discuss before coding starts.

## Step 1 — Discover project structure

Read `CLAUDE.md` (or equivalent) and the doc index (`docs/README.md`, `docs/plans/README.md`, `docs/reference/README.md`) to understand:
- Where plans live and how they're organised (roadmap, phase plans, feature backlogs)
- Where reference, architecture, and guides docs live
- Any doc conventions (PROVEN principles, lifecycle rules, linking conventions)

## Step 1b — Orient with the knowledge graph (optional but fast)

If `nkrdn` is available, run 1-2 queries to orient before searching docs:

```bash
nkrdn search "{$ARGUMENTS}" --source docs
```

This surfaces any design docs, architecture notes, or reference material indexed in the knowledge graph instantly. Use it as a first-pass triage before the deeper Explore scan. See `/code-intel` for full nkrdn usage.

## Step 2 — Find all docs relevant to $ARGUMENTS

The topic in `$ARGUMENTS` may be a single word ("combat") or a phrase ("narrative quests"). Search broadly — a topic is rarely captured in one doc.

Spawn an Explore agent with this brief:

> Search the entire docs/ directory for files related to **{$ARGUMENTS}**. Look in:
> - `docs/plans/` (roadmap, phase plans, feature backlogs, vision docs)
> - `docs/reference/` and all subdirectories
> - `docs/architecture/`
> - `docs/guides/`
>
> For each file you find:
> - Note the file path and frontmatter `status` / `tags`
> - Summarise what it covers in 1-2 sentences
> - Note which phase(s) it covers (Phase 1/2/3/vision/shipped/etc.)
> - Note whether it's in a logical cluster or sitting loose
>
> Also check for the project's roadmap (`docs/plans/roadmap.md` or similar) — read it fully so phase dependencies are clear.
>
> Be thorough. Read file contents, not just filenames. Report every relevant file you find.

## Step 3 — Assess and identify organising issues

Review the Explore agent's findings. Look for:

**Clustering gaps**: Loose reference files (3+ files on the same sub-topic not in a subdirectory) that belong together. The project rule is: 3+ docs on the same topic → create a cluster directory.

**Plan scatter**: Multiple plan files covering the same topic from different angles without clear hierarchy. If the topic spans 3+ separate plan files with no master plan structuring them, that's fragmentation — a consolidating plan doc would help.

**Stale status**: Plans with `status: active` that are actually shipped (architecture doc exists covering the same content), or `status: shipped` docs still referencing future work.

**Naming inconsistencies**: Files cited under one name but stored under another (stale cross-references).

## Step 4 — Execute clustering (no confirmation needed)

For any loose reference files that form a coherent cluster with the topic:

1. Create the cluster directory (`reference/{cluster-name}/`)
2. Move the files there
3. Find all cross-references to the moved files across the entire docs/ directory
4. Update each reference to use the new path
5. Create a `README.md` for the new cluster (following the existing cluster README pattern: one-line summary per doc, See also links to related plans/architecture docs)
6. Update the parent `reference/README.md` to add the new cluster and remove the moved root-level entries

Fix any naming inconsistencies found (files cited under a different name than their actual filename). Update all references.

Do NOT:
- Merge or rewrite plan docs (that's editorial, not clustering)
- Move plans docs (plans have their own organisation logic)
- Delete anything

## Step 5 — Present the overview

Structure the overview as:

```
## Topic: {$ARGUMENTS}

### What's shipped
{one bullet per shipped system — what it does, where it lives in code/architecture}

### Active plans (current phase work)
{one bullet per active plan — what phase, what it adds, link to doc}

### Phase breakdown
{for each phase relevant to this topic: what ships, what the exit criteria are, dependencies}

### Reference base
{the key reference docs this topic relies on — clusters and root-level docs}

### Clustering changes made
{if any files were moved, list them briefly}

### Issues flagged
{any stale statuses, scattered plans, or naming inconsistencies found — with recommendations}
```

After the overview, offer one of:
- "Plans look clean — ready to start on Phase {N} work. What do you want to tackle first?"
- "Found some fragmentation in the plans — {describe}. Want me to create a consolidating plan doc before we start?"

Keep the overview scannable. Use links. The goal is: user reads it once and knows exactly where things stand.
