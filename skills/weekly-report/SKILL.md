---
name: weekly-report
description: Generate a leadership-facing progress report from git history, dev-logs, and docs over a time window — the markdown report is the primary deliverable, with an optional matching HTML slide deck derived from it afterwards. Defaults to the past 7 days; accepts a duration ("2 weeks", "14d"), a "since <date>", or a range ("2026-06-01..2026-06-19"). Use when the user asks for a weekly report, a progress update for the CEO/manager, a deck/slides of the week, or a summary of what they've worked on over a period.
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
- **No vanity activity counts.** Per-day commit counts ("12 commits on Tuesday"), but also
  *any* raw activity tally — clips reviewed, files touched, experiments run. It reads as effort
  and says nothing. Cite a number only when it carries an outcome; otherwise describe the body
  of work. Keep commit hashes as inline provenance, not as a scoreboard.
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
- **Make every number self-explaining.** A bare `0.55 → 0.82` forces the reader to guess which
  is the old one. Lead with the current value and label the prior: "0.82, up from 0.55 last
  week". Same for counts and ratios — never an unlabelled arrow.
- **Say what a metric means for the product, honestly.** Don't let a number imply a behaviour
  it can't support: "88% precision" sold as "auto-confirm" hides that ~1 in 8 is wrong. State
  the real implication (here: the top tier still needs a human glance). A flattering label on a
  middling number is the fastest way to lose a technical reader's trust.

## Write like a person, not an LLM

Generated prose is a tell, and for a technical reader it quietly undercuts the work. Once the
draft (and the deck) read right on substance, do a humanizing pass: run **`/humanize-text`** on
the prose, or apply its checks by hand — the em-dash habit, stock triads ("deterministic,
reproducible, iterable"), the "not X — but Y" see-saw, filler ("honest", "tangible", "the
through-line", "the lesson for leadership"). Same voice for the report and the deck.

One report-specific rule on top: **no self-applied milestone labels** ("the first viable
product", "a real capability", "a genuine step-change") — they read as forced. State the result
and let the reader award the label.

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

## Slides (optional follow-on — only after the report is done)

The markdown report is the primary deliverable. The deck is a **secondary, derived
artifact**: build it only after the report is written, reviewed, and committed — and ideally
only when the user asks for slides. Never let deck work delay or dilute the report.

The deck is a **read / leave-behind** for a CEO — dense and information-rich, NOT sparse
presentation slides (see [[ceo-deck-preferences]]). A proven template lives beside this skill
at `deck-template.html` — copy it, don't rebuild the design from scratch.

### Procedure

1. **Copy the template** to `docs/briefs/week-<end-date>-update.html` (or
   `report-<start>_<end>-update.html`). It is a self-contained dark, dense, 8-slide deck with
   the full CSS, nav (keyboard/scroll/touch/dots), deep-link `#sN` hashes, and an `__IMG_HERO__`
   image placeholder.
2. **Map the report into the slides**, one informative slide each (no 101 explainers — the
   CEO knows the product; every slide carries new info). A good spine: Results dashboard →
   At a glance / through-line → How it works → the key Decision/tradeoff → what Shipped →
   Next steps. Drop the commit hashes the report carries — a deck is for the screen.
   - **Open with the result, not a label.** Slide 1 should be a compressed results dashboard —
     the headline number(s) plus the key metrics — not a vague title or a self-applied milestone
     ("first viable product"). Lead with what was achieved.
   - **Fewer slides beats padding.** The 8-slide template is a ceiling, not a quota. Cut any
     slide that's a tangent for a CEO (a parked R&D avenue, deep internals) and fold its one
     line into a neighbour. When you remove one, renumber the `0N / 0M` meta indices, the
     "N slides" text (hint + foot), and the section `id="sN"` so deep-links and nav stay correct.
   - Numbers on a slide follow the report rule: lead with the current value, label the prior
     ("0.82, up from 0.55"). If a metric table omits an obvious column the point needs (e.g.
     precision next to recall/F1), add it — and use real numbers, not illustrative ones.
3. **Frames must clearly show their subject.** Use a strong real frame for the hero; if a
   comparison frame doesn't clearly show the ball/subject, replace it with a labelled SVG
   diagram (as the depth-ceiling slide does). Never ship a frame where the point isn't visible.
4. **Embed images as base64** so the file is one portable artifact — optimize first (PIL
   `thumbnail((1440,1440))`, JPEG q80) and `.replace('__IMG_HERO__', 'data:image/jpeg;base64,'+…)`.
5. **Verify by actually looking** — screenshot and scrutinise; do NOT declare it good blind.
   With scout-browse headless the reliable full-size capture is: open the file, then
   `scout-browse goto "<file>#sN"` (foreground) → screenshot. Plain scroll/nav-dot clicks
   fight `scroll-snap` and land between slides. Check for: empty space *inside* boxes (panels
   must hug content, not stretch), text too small to read, and overflow. Also screenshot at a
   phone width (~390) — dense slides overflow there.
   - **Force a fresh load after every edit.** A hash-only `goto` does not reload the file, and
     an `open` while a browser is already running can no-op and screenshot the *stale* page
     (you'll "verify" old content). `close` then `open`. And a headless `resize` after load does
     not faithfully re-evaluate media queries, so confirm responsive / `display:none` rules by
     reading the CSS, not only by resizing.
6. **Deliver:** offer to commit and to Taildrop it (`/drop`) to the user's device.

### Hard-won layout rules (baked into the template — keep them)

- **Boxes hug their content; the block centers.** Do NOT stretch panels to fill slide height —
  that strands sparse text at the top of giant empty boxes (worse than slide-level gaps). Let
  panels size to content and center the group (`body-area{justify-content:center}`,
  `.col{justify-content:center}`).
- **Readable text.** Body ≥ ~1rem floor, labels/captions ≥ ~0.8rem. Tiny mono labels get missed.
- **Fixed-height media.** Images are banners (`height:min(46vh,360px)`), diagrams a fixed
  height — never `flex:1` stretched.
- **Keep the honest tradeoffs** (recall-vs-F1 etc.) — the user wants those on a slide, not hidden.
- **Mobile fallback.** The deck is desktop-first (scroll-snap, fixed-height slides), so dense
  slides clip on a phone. At `@media (max-width:760px)` let slides flow — `height:auto;
  overflow:visible; scroll-snap-type:none` — and hide the nav-dots/hint (they overlap edge
  content). Baked into the template; keep it.
