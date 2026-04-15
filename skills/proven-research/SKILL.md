---
name: proven-research
description: Conduct PROVEN-quality research on a topic. Searches alphaxiv for academic papers, WebSearch for practitioner sources, and writes a reference doc with full citations and evidence tiers. Use when the user asks to research a topic, find evidence for a claim, or write a reference doc.
---

# PROVEN Research

You are conducting evidence-based research following the PROVEN principles. Your goal is to produce a reference document with full citations, evidence tiers, and verifiable claims.

## Research Sources (use ALL of these)

### 1. alphaxiv (Primary — Academic Papers)

Use the alphaxiv MCP tools to find high-quality, recent academic research:

- `mcp__alphaxiv__embedding_similarity_search` — semantic search for concepts and methods. Write detailed 2-3 sentence queries covering the topic from multiple angles.
- `mcp__alphaxiv__full_text_papers_search` — keyword search for specific methods, author names, or paper titles.
- `mcp__alphaxiv__get_paper_content` — retrieve full paper content and structured overviews.
- `mcp__alphaxiv__answer_pdf_queries` — extract specific findings from papers.

**Always search alphaxiv first.** It has 2.5M+ papers and surfaces the latest research that WebSearch may miss.

### 2. PubMed E-utilities (Primary — Biomedical/Health Science)

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

### 3. WebSearch (Secondary — Practitioner Sources)

Use WebSearch for:
- Practitioner blogs and industry analysis
- Exchange documentation and fee schedules
- Regulatory information and government sources
- News and current events
- Sources not on arXiv or PubMed (finance journals, books)

### 4. scout-browse (Tertiary — Sites That Block Bots)

Use `scout-browse` via Bash for sites that block raw HTTP (Google Scholar, some journals). The CLI is symlinked at `/usr/local/bin/scout-browse` and runs without any venv activation:
```bash
scout-browse open "https://scholar.google.com/scholar?q=your+query"
cat .scout-browse/page-*.yml
scout-browse close
```

## Research Process

1. **Search alphaxiv** with 2-3 varied queries covering different angles of the topic
2. **Search PubMed** when the topic touches health, exercise science, nutrition, or clinical domains — these journals are not on arXiv
3. **Read key papers** using `get_paper_content` (alphaxiv) or `efetch` abstracts (PubMed) for the most relevant results
4. **Search WebSearch** for practitioner perspectives and non-academic sources
5. **Cross-reference** — do academic findings align with practitioner experience?
6. **Write the reference doc** following PROVEN format

## Output Format

Write a reference doc at `docs/reference/<topic-name>.md` with:

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
|------|-----------|
| 1 | Systematic review / meta-analysis |
| 2 | RCT / peer-reviewed empirical study |
| 3 | Observational / cohort study |
| 4 | Narrative review |
| 5 | Practitioner opinion / textbook |

### N — Not Duplicated
Check existing docs before creating new ones. Update rather than duplicate.

## After Writing

1. Update `docs/reference/README.md` with the new entry
2. Cross-reference from existing docs where relevant
3. If the research was prompted by an experiment, link back to the experiment log
