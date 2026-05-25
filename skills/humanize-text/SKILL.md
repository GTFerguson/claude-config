---
name: humanize-text
description: Make AI-drafted prose read like a human wrote it. Use for an "AI authoring pass", to strip AI tells / de-slop text, or when a draft "sounds like AI". Hunts the statistical, vocabulary, punctuation, structural, and tonal signatures of LLM writing and rewrites them out while preserving meaning, facts, and any word/character limits.
---

# Humanize Text — the AI authoring pass

Rewrite AI-drafted prose so it reads like the author wrote it, not like a language model being helpful. This is **craft, not deception** — the goal is text that sounds like *someone*, not text generated for *everyone*.

Match the target register. Humanising a grant application or a report means fixing rhythm, vocabulary, and punctuation — **not** adding slang, lowercase, or fragments that don't belong. Humanising a social post may mean exactly those things. Imperfection must be authentic to the author and the context; never bolt on a generic "casual" voice.

## When to use

- The user asks for an "AI authoring pass", to "humanise", "de-slop", or says a draft "reads like AI".
- You've just generated substantial prose that will be read by people who distrust AI text (grant reviewers, editors, hiring managers, an audience).

## When not to

- Code, structured data, or terse factual notes — tells don't apply.
- Text the user wants left verbatim.

## The tells — hunt these

**Punctuation**
- **Em-dash overuse.** The single loudest tell. More than ~2 em dashes in a piece (or 3+ in a paragraph) reads as AI. Replace most with commas, periods, parentheses, or a colon. Keep one or two for genuine emphasis.
- **Colon-then-list reflex.** "Here's what X looks like:" + bullets, where prose would be natural.

**Vocabulary** — replace LLM-favoured words with plain ones:

| LLM reaches for | Write instead |
|---|---|
| delve into | look at, go into |
| crucial, pivotal | key, important (or just cut) |
| leverage (verb) | use |
| robust, comprehensive | strong, full / thorough |
| showcase (verb), underscore(s) | show, shows |
| nuanced, multifaceted | (usually cut, or "has several sides") |
| serves as a | is |
| features, offers | has |
| testament to, ever-evolving, seamless | (rephrase concretely) |
| realm, landscape (abstract), tapestry, intricate, meticulous | (almost always cut/replace) |

Also cut hedging/transition filler: "it's important to note", "it's worth noting", "generally speaking", "in conclusion", "this is a testament to", "at the end of the day".

**Structure**
- **Rule-of-three addiction.** AI stacks tricolons ("fast, cheap, and reliable"). Break some into two items or one.
- **Correlative/contrast templates.** "Not only X but also Y", "it's not just X — it's Y", "X isn't the bottleneck; Y is." Used once it lands; used repeatedly it's a fingerprint. Vary or cut.
- **Uniform paragraph template.** Topic sentence → support → tidy summary, every time. Break it: start with the point, or with a detail; end abruptly sometimes.
- **List addiction & nominalizations.** Prefer prose over bullets where it flows; prefer verbs over noun-phrases ("we decided" not "the decision was made").
- **Balanced to mush.** AI presents both sides and hedges. Take a position where the author would.

**Rhythm (burstiness)**
- AI sentences trend to the same length. Humans mix. Vary deliberately: some short. Some that run longer and carry a couple of clauses before they land. Never three same-length sentences in a row.

**Tone**
- Cut sycophantic / relentlessly-positive framing and any "Great question!"-style opener — start on substance.
- Allow real affect where authentic: doubt, frustration, a flat "this is hard."

**Specificity** (the thing AI can't fake)
- Replace abstractions with named people, places, dates; "significant"/"substantial" with the actual number; general claims with the concrete instance.

## Workflow

1. **Scan** the draft against the tells above.
2. **Rewrite** targeting them — surgically where the text is otherwise good; don't homogenise good writing into a different voice.
3. **Respect limits.** Re-check word/character caps after editing (humanising can add or cut length).
4. **Read it aloud** (mentally). If it sounds like a press release or could've been written by anyone about anything, it needs another pass.

## A note on prompting

If you're instructing *another* model to write in-voice, don't rely on negatives like "don't use delve" — models process negatives poorly and often produce the banned pattern anyway. Use **positive directives** ("use plain verbs; vary sentence length; take a position") plus a short hard banlist for the worst offenders, and 2–5 in-voice examples. Asking the model to analyse a voice sample before writing improves the match.

## Further evidence

The full evidence base — perplexity/burstiness research, the overused-vocabulary studies (Kobak et al. 2025; Juzek & Ward 2025), detection-rate studies, and the social-media-specific material — lives in `common-knowledge/social/authentic-ai-text.md` if available. This skill is the general, actionable distillation.
