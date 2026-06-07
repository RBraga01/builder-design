---
name: ai-output-design
description: Use when designing how AI-generated content is rendered — streaming text, structured data, citations, code blocks, and uncertainty signals. Covers both visual rendering and the accessibility layer.
---

# AI Output Design

## The Law

```
AI OUTPUT IS NOT STATIC CONTENT.
"Just render the markdown" and "the model formats it" both ship walls of unstyled text with no hierarchy, no confidence signals, and no accessibility layer.
Defined rendering rules + typographic hierarchy + confidence signals IS output design.
```

## When to Use

Trigger when:
- Designing how model responses are displayed in any UI surface
- Adding markdown rendering to an AI response container
- Designing how structured data from the model (tables, lists, code) is presented
- Designing the visual treatment for uncertainty or low-confidence responses
- Reviewing whether existing AI output rendering is production-quality

## When NOT to Use

- Output that is always structured JSON consumed by the system, not displayed to users
- Backend pipelines where no human reads the model output directly

## The Output Rendering Stack

### 1 — Markdown Rendering

Model responses contain markdown. Define which elements to render and how:

| Element | Render as | Notes |
|---|---|---|
| `# H1` | Use sparingly in responses — demote to H3 | H1 inside a response clashes with page hierarchy |
| `**bold**` | `<strong>` | Full weight only; no extra color |
| `_italic_` | `<em>` | Used for emphasis, not decoration |
| `` `inline code` `` | `<code class="inline">` | Monospace, tinted background |
| ` ```code block``` ` | Syntax-highlighted `<pre><code>` | Language label, copy button, max-height with scroll |
| `- list` | `<ul>` with custom bullet | 0.5rem gap between items |
| `1. ordered` | `<ol>` | Numbers bold, content regular weight |
| `> blockquote` | Left bar, muted text | Use for citations or model asides |
| `| table |` | Responsive table | Horizontal scroll on mobile, sticky header |
| `---` | `<hr>` | Thin, muted; use sparingly |

**Rules:**
- Never render raw HTML from model output (XSS risk — sanitise or use a safe renderer)
- H1 and H2 inside responses should be demoted (H1 → H3, H2 → H4) to preserve page hierarchy
- Long code blocks: max-height 400px, scroll inside, copy button visible without scrolling

### 2 — Typographic Hierarchy in Responses

AI responses can be very long. Typography is the only structural tool.

```css
.ai-response {
  font-size: 1rem;           /* Body: 16px */
  line-height: 1.7;          /* Generous for readability */
  max-width: 72ch;           /* Reading line length */
  color: var(--ink);
}

.ai-response h3 { font-size: 1.15rem; font-weight: 700; margin-top: 1.5em; }
.ai-response h4 { font-size: 1rem;    font-weight: 600; margin-top: 1.25em; }
.ai-response p  { margin: 0.75em 0; }
.ai-response ul,
.ai-response ol { padding-left: 1.5em; margin: 0.75em 0; }
.ai-response li { margin: 0.3em 0; }
```

Line length: cap at 65–75ch. AI responses are dense — long lines prevent reading.

### 3 — Structured Data Rendering

When the model produces tables, cards, or structured lists:

**Tables:**
```html
<div class="table-wrapper" role="region" aria-label="AI-generated table" tabindex="0">
  <table>
    <thead><tr><th scope="col">...</th></tr></thead>
    <tbody>...</tbody>
    <caption>Source: AI-generated on [date]</caption>
  </table>
</div>
```

- `role="region"` + `tabindex="0"` makes the scroll container keyboard-navigable
- Caption is required for AI-generated tables (marks provenance)
- Horizontal scroll inside `.table-wrapper`, not the page

**Long structured lists from the model:**
- > 10 items: add a "Show all N items" expand
- Items with sub-structure: use a card list, not a flat list

### 4 — Uncertainty and Confidence Signals

Not every model response should look equally authoritative.

```
High confidence (no hedging detected, grounded in retrieved context):
→ Normal rendering

Low confidence (hedging phrases, outside knowledge cutoff, no retrieved context):
→ Amber left bar + "Low confidence — verify before using"
→ [Show sources] or [Check manually] action

Model refusal or "I don't know":
→ Distinct visual treatment (grey, softer)
→ "I don't have reliable information about this" — never leave blank
→ [Rephrase] or [Try a different question] action
```

Implement confidence detection with a post-processing step — do not rely solely on the model to label its own uncertainty.

### 5 — Progressive Disclosure for Long Responses

AI responses have no natural length limit. Design for length:

- Responses over 800 words: show "Jump to sections" anchor links if there are headings
- Collapsible sections for code blocks over 50 lines
- "Show more" for lists over 10 items
- Responses over 1500 words: sticky summary bar ("Reading: Section 2 of 4")

## The Process

### Step 1 — Define the Markdown Rendering Rules

Create an explicit list of which markdown elements your surface renders and how. Use the table in Section 1 as your starting point. Any element not listed is undefined behaviour in production.

### Step 2 — Apply the Typographic Hierarchy

Add the CSS in Section 2 (or its equivalent in your stack) to the response container. Line height `1.7` and `max-width: 72ch` are not optional — long AI responses with tight line height and full-width layout are measurably harder to read.

### Step 3 — Implement Structured Data Rendering

For tables: `role="region"` + `tabindex="0"` on the scroll wrapper, `<caption>` required. For long lists: define the expand threshold (default: 10 items).

### Step 4 — Add Confidence Signals

Implement the post-processing step that detects hedging language and applies the amber treatment. A regex over `["I think", "I'm not certain", "approximately", "I believe", "may", "might"]` in the response text is a minimum viable implementation.

### Step 5 — Verify Progressive Disclosure Thresholds

Test with a response over 800 words (section anchor links), a code block over 50 lines (collapsible), and a list over 10 items (expand). If your rendering system doesn't handle these, they ship as walls of content.

## Rationalization Red Flags

These thoughts mean output design was skipped — stop:

- *"Just render the markdown"* — unstyled markdown in a product context reads as developer output, not designed product
- *"The model will format it nicely"* — the model produces markdown; the product controls rendering
- *"Users can read long responses"* — they can read; they won't; design for scannable structure
- *"Uncertainty signals are complex to implement"* — a CSS class and a left border are not complex; the complexity is in not doing it

## Completion Statement Format

When ai-output-design is satisfied, state it like this:

```
Output design complete.
Surface: <response container name>

Rendering:
  Markdown elements: all 11 elements defined with visual treatment ✓
  H1/H2 demoted: yes ✓ / Code blocks: syntax-highlighted, max-height, copy button ✓
  Line length: capped at 72ch ✓ / Line height: 1.7 ✓

Structured data:
  Tables: role="region" + tabindex, caption, responsive scroll ✓
  Long lists: > 10 items expandable ✓

Confidence signals:
  Low confidence: amber bar + verify message + action ✓
  Refusal / no-data: distinct grey treatment + alternative action ✓

Progressive disclosure: responses > 800 words have section anchors ✓

Documented in: design/specs/<feature>-output.md ✓
```

## Why This Matters

Undesigned AI output reads as a developer tool, not a product. Typography, line length, element hierarchy, and uncertainty signals are what separate a rendered model response from a polished product feature. The model generates tokens; the UI design determines whether users can read, trust, and act on what it produces.
