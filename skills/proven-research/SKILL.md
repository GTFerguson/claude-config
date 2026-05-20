---
name: proven-research
description: Conduct PROVEN-quality research on a topic. Searches alphaxiv for academic papers, PubMed for biomedical research, and WebSearch for practitioner sources, then writes reference docs with full citations and evidence tiers. Supports an optional two-layer pipeline (foundational research in /home/gary/projects/common-knowledge/, then project-specific research in the current project's docs/reference/) for topics with cross-domain foundations. Use when the user asks to research a topic, find evidence for a claim, or write a reference doc.
---

# PROVEN Research

You are conducting evidence-based research following the PROVEN principles. Your goal is to produce reference documents with full citations, evidence tiers, and verifiable claims.

## Step 1 — Decide the scope: one layer or two?

Before searching, decide where the findings belong. Two layers exist:

```
Layer 1 — common-knowledge/          (foundational, cross-domain)
  /home/gary/projects/common-knowledge/
  Findings that would be equally useful in a completely different project.

Layer 2 — <project>/docs/reference/   (project-specific)
  Findings scoped to the current product, audience, or codebase.
  Wiki-links back to Layer 1 instead of duplicating it.
```

Use the table to classify each finding:

| Goes in common-knowledge (Layer 1) | Goes in project reference (Layer 2) |
|------------------------------------|--------------------------------------|
| How Google's ranking systems work | Target keywords for this product's niche |
| Evidence on Core Web Vitals as a ranking factor | Competitor SERP analysis for this product |
| Search intent classification theory | Content gap analysis for this audience |
| Structured data schema standards | Specific pages to build for this product |
| E-E-A-T signal evidence | This product's programmatic SEO plan |
| Programmatic SEO as a pattern | Borough/neighbourhood keyword data (goodlet) |

**Heuristic:** if a finding would be equally useful in a completely different project, it belongs in common-knowledge.

If the topic is purely project-specific, skip the Layer 1 work and go straight to Layer 2 (steps 2–5 still apply, just to one directory).

If the topic has both, **build Layer 1 first**, then Layer 2 builds on it via wiki-links.

## Step 2 — Audit what already exists

```bash
nkrdn search "<topic>" --source docs
```

Check both common-knowledge and the current project's reference for existing coverage before researching. Update existing docs rather than creating overlapping ones (PROVEN's N principle).

## Step 3 — Search the sources

### 3a. alphaxiv (Primary — Academic Papers)

Use the alphaxiv MCP tools to find high-quality, recent academic research:

- `mcp__alphaxiv__embedding_similarity_search` — semantic search for concepts and methods. Write detailed 2-3 sentence queries covering the topic from multiple angles.
- `mcp__alphaxiv__full_text_papers_search` — keyword search for specific methods, author names, or paper titles.
- `mcp__alphaxiv__get_paper_content` — retrieve full paper content and structured overviews.
- `mcp__alphaxiv__answer_pdf_queries` — extract specific findings from papers.

**Always search alphaxiv first.** It has 2.5M+ papers and surfaces the latest research that WebSearch may miss.

### 3b. PubMed E-utilities (Primary — Biomedical/Health Science)

Use PubMed's free API for biomedical, health science, exercise physiology, and clinical research not covered by arXiv. No auth required.

**Search** — find PMIDs matching a query:
```
WebFetch URL: https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=YOUR+QUERY+TERMS&retmax=20&retmode=json
```

**Fetch abstracts** — retrieve structured abstracts by PMID:
```
WebFetch URL: https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=PMID1,PMID2,PMID3&retmode=text&rettype=abstract
```

Use PubMed when the topic falls within health/exercise/nutrition/clinical domains — it indexes journals that arXiv does not (JSCR, Sports Medicine, MSSE, BJSM, etc.). Combine with alphaxiv for full coverage.

### 3c. WebSearch (Secondary — Practitioner Sources)

Use WebSearch for:
- Practitioner blogs and industry analysis
- Exchange documentation and fee schedules
- Regulatory information and government sources
- News and current events
- Sources not on arXiv or PubMed (finance journals, books)

### 3d. scout-browse (Tertiary — Sites That Block Bots)

Use `scout-browse` via Bash for sites that block raw HTTP (Google Scholar, some journals). The CLI is symlinked at `/usr/local/bin/scout-browse` and runs without any venv activation:
```bash
scout-browse open "https://scholar.google.com/scholar?q=your+query"
cat .scout-browse/page-*.yml
scout-browse close
```

## Step 4 — Write the reference doc(s)

### Layer 1 — common-knowledge (only if topic warrants it)

Write foundational docs to `/home/gary/projects/common-knowledge/<cluster>/<topic>.md`. Update `/home/gary/projects/common-knowledge/<cluster>/README.md` and the root `/home/gary/projects/common-knowledge/README.md` with pointers.

### Layer 2 — project reference

Write project-specific docs to `<project>/docs/reference/<topic-name>.md`. When building on Layer 1, wiki-link rather than duplicate:

```markdown
The ranking factor evidence base is at [[ranking-factors]].
Applying that to goodlet's target queries: ...
```

### Frontmatter and structure (both layers)

```markdown
---
title: <Topic Title>
created: <date>
updated: <date>
status: active
tags: [relevant, tags]
---

# Topic Title

<1-2 sentence summary of what this doc covers and why it matters.>

## 1. First Section

<Evidence-tiered findings with inline citations.>

(Tier N: Author et al., Year, *Journal* Volume(Issue):Pages, n=SampleSize)

## References

- Full reference list at the end
```

## Step 5 — Index, commit, and reindex

1. Update the relevant README(s) with the new entry/entries.
2. Cross-reference from existing docs where relevant.
3. If the research was prompted by an experiment, link back to the experiment log.
4. **If you wrote to common-knowledge**, commit it as its own clean change:
   ```bash
   cd /home/gary/projects/common-knowledge
   git add -A
   git commit -m "<topic cluster>: <one-line summary>"
   ```
   One commit per research session or topic cluster. Do not batch unrelated topics.
5. **Rebuild nkrdn** so the workspace graph reflects the new docs:
   ```bash
   nkrdn workspace rebuild common-knowledge   # if Layer 1 was touched
   nkrdn workspace rebuild <current-project>  # if Layer 2 was touched
   ```

## PROVEN Principles (Mandatory)

### P — Provenance
Every claim traces to a named, dated source.

### R — Research-First
Document findings BEFORE writing code.

### O — One Topic Per Doc
Split when a doc exceeds ~200 lines.

### V — Verifiable
Include sample size, population, effect size, journal name.

### E — Evidence-Tiered
Label every source:

| Tier | Source Type |
|------|-------------|
| 1 | Systematic review / meta-analysis |
| 2 | RCT / peer-reviewed empirical study |
| 3 | Observational / cohort study |
| 4 | Narrative review |
| 5 | Practitioner opinion / textbook |

### N — Not Duplicated
Check existing docs before creating new ones. Update rather than duplicate. The two-layer model exists to prevent duplication across projects — promote shared foundations to common-knowledge instead of re-researching them per project.
