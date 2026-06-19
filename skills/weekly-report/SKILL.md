---
name: weekly-report
description: Generate a leadership-facing progress report from git history, dev-logs, and docs over a time window. Defaults to the past 7 days; accepts a duration ("2 weeks", "14d"), a "since <date>", or a range ("2026-06-01..2026-06-19"). Use when the user asks for a weekly report, a progress update for the CEO/manager, or a summary of what they've worked on over a period.
---

# Weekly Report

Produce a single report of what the user has worked on over a time window, suitable for a
CEO or other leadership reader. The audience is technical-but-not-in-the-weeds: lead with
outcomes and the strategic picture, but **keep file paths and commit hashes inline as
provenance** so the reader can verify any claim themselves.

## Resolve the time window first

Default: the **past 7 days** ending today. Otherwise parse the argument:

| Argument form | Window |
|---|---|
| *(none)* | last 7 days |
| `2 weeks`, `14d`, `last month` | that duration back from today |
| `since 2026-06-01` | from that date to today |
| `2026-06-01..2026-06-19` | explicit start..end |

`git log` accepts `--since`/`--until` and durations directly. Always state the resolved
window (e.g. "2026-06-13 → 2026-06-19") at the top of the report so it's unambiguous.

## Gather the source material

Run these in parallel, scoped to the window. **Read the dev-logs — do not summarise from
commit subjects alone.** The commit log tells you *what* changed; the dev-logs and
KEY-FINDINGS tell you *why* and *what was learned* (including the failures).

```bash
# Commits in the window (subjects)
git log --since="<start>" --until="<end>" --pretty=format:"%h|%ad|%s" --date=short

# Commits with file stats — shows which areas/files each commit touched
git log --since="<start>" --until="<end>" --stat --pretty=format:"=== %h %ad %s ==="

# Dev-logs and docs modified in the window
find docs/dev-log -name "*.md" -newermt "<start>" -type f
find docs -name "*.md" -newermt "<start>" -type f | grep -v dev-log
```

Then **Read** the KEY-FINDINGS.md and the dev-log entries for each active workstream, plus
any plan docs that completed in the window. Group the commits into workstreams (usually 2–4)
and find the **through-line** that connects them — the report's spine.

### Commit dates lie about effort — anchor to the work, not the calendar

Commit timestamps record when work *landed*, not when it was *done*. Work is often committed
in batches a day or two after the experiments ran, which compresses the apparent timeline and
**undersells the effort** — a real problem for a report read as a measure of output.

- **Cross-check dev-log `created`/`updated` dates and file mtimes** against commit dates. If a
  dev-log documents work dated before its commit, the work started earlier than the commit
  implies. If in doubt about the true span, **ask the user** — they know which days they worked.
- **Never use per-day commit counts as an effort meter** ("12 commits on Tuesday"). It reads
  as activity but is just the commit calendar. Describe the *body of work*; keep commit hashes
  only as inline provenance.
- Anchor the narrative to what was built and learned over the window, not to the days commits
  happened to be pushed.

## What the report must contain

For each workstream, cover **all the work, including what failed**. A negative result is a
deliverable: it closes an avenue and stops the team re-spending the budget. For every
abandoned approach, give its *measured* failure mode, not just "didn't work".

Specific things that are easy to under-report and must be included:

- **Every attempt, successful or not** — dead levers, rejected approaches, pilots that were
  parked. Name each with the reason it failed and the evidence.
- **Honest metric tradeoffs.** If a metric was edged up at the cost of another (e.g. F1 up
  but recall down), say so explicitly and explain why it was accepted or rejected. These
  judgement calls are exactly what leadership wants visibility into — do not hide them
  behind a single headline number.
- **Distrust small-n wins.** Report full-distribution numbers, not curated-sample peaks. If
  a result collapsed when evaluated honestly, that *is* the finding.
- **Don't promote "blocked" to "dead".** A lever that failed once due to *fixable* input
  quality (poor labels, sparse data, off-frame points) is an open opportunity, not exhausted.
  Reserve "exhausted / dead end" for approaches with a *fundamental* measured failure. When
  unsure which it is, **ask the user** — dev-logs written mid-experiment often overstate
  finality, and the user's domain judgement overrides an inherited "dead end" claim.
- **Check for contradictions before finalising.** Nothing labelled a dead end in the body
  should reappear as a recommendation in Next Steps. If it does, the body is wrong — the
  thing is open. Grep the draft for "dead", "exhausted", "ceiling", "wall" and reconcile each
  against the Next Steps.
- **Frame work as capability gained, not bug fixed**, where that's the truer description.
  "We extended the system so X is now possible" beats "we fixed a bug that lost X" when both
  are true — lead with what the team can now do.

## Next steps — get the altitude right

This is the section most likely to come out wrong. Next steps are for the reader's planning,
so they must be **strategic and highest-leverage**, framed by outcome and impact:

- **Lead with the work that unlocks the biggest improvement** — usually the thing that
  attacks the documented ceiling directly, not an incremental tweak around it.
- **Connect next steps back to what shipped** — show how this week's work enables them.
- **Demote, or omit, internal housekeeping.** Doc graduation, plan cleanup, refactors,
  test backfill, validation passes — leadership does not track these. Keep them out, or
  collapse to a single "follows once X is solid" line at the end.
- If the user describes the real plan in conversation, that overrides whatever the logs
  imply was "next" — the logs record options, the user knows the priority.

## Output

Write to `docs/briefs/week-<end-date>.md` (single-week) or
`docs/briefs/report-<start>_<end>.md` (custom range), with frontmatter:

```yaml
---
title: "Weekly Report — Week ending <end-date>"
scope: [<workstreams>]
created: <end-date>
tags: [weekly-report, ...]
---
```

Structure: **At a glance** (the workstreams + through-line) → one section per workstream
(what shipped, attempts incl. failures, tradeoffs) → **Where things stand** → **Next steps**.
Use Obsidian wiki-links (`[[dev-log-entry]]`) to source docs and a blank line before every
table (this vault renders in Obsidian).

After writing, give the user a short summary and offer to commit it. **Stage only the report
file** and commit atomically — this repo is often shared with a concurrent agent.

## Output-style note

If the explanatory output style is active, the conversational summary may include `★ Insight`
blocks — but **never put them in the report file itself**. The report is a standalone
artifact for a non-Claude reader.
