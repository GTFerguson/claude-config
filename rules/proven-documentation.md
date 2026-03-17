# PROVEN Documentation Principles

Reference documentation is the project's institutional memory. Every design decision, algorithm constant, and domain assumption must trace back to documented evidence. Without provenance, knowledge decays into folklore.

## The PROVEN Principles

### **P** — Provenance

Every claim traces to a named, dated source. Include author(s), year, title, and journal/publisher.

**Bad — Unsourced claim:**
```markdown
Training volume should be 10-20 sets per muscle group per week for hypertrophy.
```

**Good — Sourced claim:**
```markdown
A dose-response relationship exists between weekly set volume and hypertrophy,
with 10+ weekly sets producing greater effect sizes (ES=0.24) than fewer than 5
(ES=0.07) (Schoenfeld et al., 2017, *Journal of Sports Sciences* 35(11):1073-1082).
```

### **R** — Research-First

Document findings in `docs/reference/` **before** writing code. No implementation without grounding. If you research a topic to inform a design decision, record the findings as a reference doc first — then cite it from the architecture doc or code comments.

**Bad — Research lost in agent context:**
```
Agent searches for "SRA recovery windows", finds papers,
uses numbers directly in code, never records the findings.
```

**Good — Research preserved:**
```
1. Search academic sources
2. Write docs/reference/sra-recovery-windows.md with citations
3. Implement algorithm citing the reference doc
4. Architecture doc references the same source
```

### **O** — One Topic Per Doc

Each reference doc covers a single coherent topic. Split when a doc exceeds ~200 lines. Cross-reference between docs using links rather than duplicating content.

**Bad:** A single doc covering "Training Science" with volume, periodization, recovery, and nutrition all mixed together.

**Good:** Separate docs for `progressive-overload-and-periodization.md`, `overtraining-and-fatigue-management.md`, `sleep-and-recovery-science.md`.

### **V** — Verifiable

Include enough detail to check the original source: sample size, population (trained/untrained), effect size, confidence intervals, journal name. A reader should be able to find and verify every claim.

**Bad — Vague reference:**
```markdown
Studies show that higher volume produces more hypertrophy.
```

**Good — Verifiable reference:**
```markdown
In 34 resistance-trained men (>2 years experience), those performing 5 sets
per exercise achieved greater hypertrophy than those performing 1 set, though
the marginal gain from 3 to 5 sets was smaller than from 1 to 3 sets
(Schoenfeld et al., 2019, *JSCR* 33(12), n=34).
```

### **E** — Evidence-Tiered

Label the quality of each source. Not all evidence is equal. When mixing tiers, state which tier a claim comes from.

| Tier | Source Type | Example |
|------|-----------|---------|
| 1 | Systematic review / meta-analysis | Schoenfeld et al. (2017) dose-response meta-analysis |
| 2 | Randomized controlled trial (RCT) | Amirthalingam et al. (2017) 5 vs 10 sets RCT |
| 3 | Observational / cohort study | Bartholomew et al. (2008) stress and strength gains |
| 4 | Narrative review | Stults-Kolehmainen & Sinha (2014) stress-activity review |
| 5 | Practitioner opinion / textbook | Israetel et al. (2015) volume landmarks framework |

**Bad — Mixing tiers without labeling:**
```markdown
MEV is 6-8 sets per week (Israetel, 2015) and volume has a dose-response
relationship with hypertrophy (Schoenfeld, 2017).
```

**Good — Tiers labeled:**
```markdown
Volume has a dose-response relationship with hypertrophy (Tier 1: Schoenfeld
et al., 2017, meta-analysis of 15 studies). The MEV/MAV/MRV framework
operationalises this into per-muscle landmarks (Tier 5: Israetel, Hoffmann &
Smith, 2015, practitioner textbook with indirect meta-analytic support).
```

### **N** — Not Duplicated

The reference library is the single source of truth. Update existing docs rather than creating overlapping ones. Before creating a new doc, check if the topic is already covered. If it partially overlaps, either extend the existing doc or split it cleanly with cross-references.

## Citation Format

Use inline parenthetical citations with enough detail to locate the source:

```markdown
(Author et al., Year, *Journal* Volume(Issue):Pages, n=SampleSize)
```

For frequently cited works, a full reference can go in a "References" section at the end of the doc:

```markdown
## References

- Schoenfeld BJ, Ogborn D, Krieger JW (2017). Dose-response relationship
  between weekly resistance training volume and increases in muscle mass:
  A systematic review and meta-analysis. *Journal of Sports Sciences*,
  35(11):1073-1082. doi:10.1080/02640414.2016.1210197
```

## When to Write a Reference Doc

- Before implementing any algorithm that depends on domain knowledge
- When research is conducted to answer a design question
- When external sources inform thresholds, constants, or heuristics in code
- When a topic comes up repeatedly and the same sources keep being re-searched

## When NOT to Write a Reference Doc

- For implementation details (those go in `docs/architecture/`)
- For how-to instructions (those go in `docs/guides/`)
- For project plans (those go in `docs/plans/`)
- For trivially verifiable facts that don't need citations

## When to Write an Architecture Doc

Architecture docs explain **how a system works and why it was designed that way**. The same PROVEN quality principles apply — decisions need rationale, not just description.

Plans come before implementation; architecture docs come after. A plan captures design intent, an architecture doc captures what was actually built and why. The lifecycle is: **plan → implement → commit → architecture doc → delete/archive plan**.

- **When a feature or system ships** — once code is committed and stable, graduate the design knowledge from the plan into an architecture doc. Don't wait — the context is freshest right after shipping.
- **When significantly changing an existing system** — update the architecture doc to reflect the new reality
- **When design decisions aren't obvious from the code** — tradeoffs, rejected alternatives, and "why not the simpler approach" belong in architecture docs, not code comments
- **When no plan existed** — if a system was built without a plan doc, it still needs an architecture doc once it ships

### What an Architecture Doc Should Cover

- **Purpose** — what problem the system solves and why it exists as a separate component
- **How it works** — data flow, key algorithms, integration points with other systems
- **Design decisions** — why this approach over alternatives, with rationale inline (not in a separate decisions directory)
- **Configuration** — what's tuneable and where the knobs are
- **Boundaries** — what's in scope and what's deliberately excluded

## Directory Organisation

Documentation directories should stay navigable as they grow. Structure should emerge from content, not be planned upfront.

- **Cluster by topic** — when a directory reaches ~10 files, group related docs into subdirectories. Don't wait until it's unmanageable.
- **Place new docs in existing subdirectories** — when adding a doc, find the most relevant subdirectory rather than dropping it in the parent.
- **Create subdirectories when a cluster forms** — if 3+ docs share a topic and no subdirectory exists, create one and move them together.
- **Maintain a `README.md` index** — when a directory has subdirectories, keep a root-level index with links to every doc organised by cluster. Update it when adding docs or subdirectories.
- **Keep it organic** — subdirectory names should describe what's inside, not impose a taxonomy. Rename or restructure when the content outgrows the labels.
