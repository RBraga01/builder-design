---
name: ai-component-patterns
description: Use when designing or implementing any of the 6 core AI UI components. Each has specific patterns, pitfalls, and required sub-components that generic UI components don't address.
---

# AI Component Patterns

## The Law

```
AI UI COMPONENTS ARE NOT GENERIC UI COMPONENTS.
"A textarea works for prompt input" and "a div works for streaming" ship components missing required sub-components — no cursor, no stop button, no live region, no token counter.
All required sub-components of all 6 AI-native patterns, fully implemented, IS an AI component.
```

## When to Use

Trigger when:
- Building any new AI feature UI component from scratch
- Auditing an existing component before it ships
- Replacing a generic component (textarea, div) that is being used as an AI-native one
- Reviewing a PR that introduces chat, streaming output, citations, agent logs, or prompt input

## When NOT to Use

- Components that display only static, pre-rendered content (no model calls, no streaming)
- Internal admin tools where the audience is developers who understand the system's raw state
- Non-interactive AI outputs consumed by the system, not displayed to users

## The Process

### Step 1 — Identify the Component Type

From the 6 types below, identify which AI-native components this feature requires. A chat interface may need: Prompt Input + Streaming Output + Citation Display + Empty State. An agent view may need: Agent Action Log + Uncertainty Indicator + Streaming Output.

### Step 2 — Check Each Required Element

For every component identified, use the Required Elements checklist as a review gate. A component is not done until every required element is present. Not most. Every.

### Step 3 — Fix Pitfalls Before Ship

Each component has a Pitfalls list. These are the most common production failures. Check each pitfall explicitly — don't rely on "I didn't do that."

### Step 4 — Complete the Completion Statement

Produce the Completion Statement Format below. Filling in real component names and real checkboxes is the test. Vague statements ("all components done") cannot satisfy it.

## The 6 AI-Native Components

### 1 — Prompt Input

The user-facing text entry for AI interaction.

**Required elements:**
```
┌─────────────────────────────────────────────────┐
│  [Prompt suggestions if empty]                  │
│  ┌───────────────────────────────────────────┐  │
│  │ Textarea (auto-resize, max 8 lines)        │  │
│  │ Character/token counter (if limited)       │  │
│  └───────────────────────────────────────────┘  │
│  [Attach] [Voice]     [Clear]  [Send ▶] (Cmd+↵) │
└─────────────────────────────────────────────────┘
```

**Non-negotiable behaviours:**
- Auto-resize: grows with content up to `max-height`, then scrolls
- Keyboard: `Cmd/Ctrl + Enter` sends; `Enter` inserts newline (not sends)
- Disabled during generation with a `[Stop]` button replacing `[Send]`
- `aria-label="Message to AI"` on the textarea
- Character / token counter appears at 80% of limit, red at 95%
- Placeholder text gives at least one concrete example of what to ask

**Pitfalls to avoid:**
- Fixed-height textarea that overflows without scrolling
- Enter to send (breaks multi-line input)
- No token count feedback (user doesn't know why their message was rejected)
- No way to stop generation once started

### 2 — Streaming Output

The container that renders model tokens as they arrive.

**Required elements:**
```html
<div role="log" aria-live="polite" aria-atomic="false" class="response-container">
  <!-- Rendered markdown / text injected here -->
  <span class="streaming-cursor" aria-hidden="true">▋</span>
</div>
```

**Non-negotiable behaviours:**
- Streaming cursor (`▋` or `|`) visible while generating; hidden on completion
- Cursor is `aria-hidden="true"` — it is decorative
- Markdown rendered in real time (code blocks, lists, bold)
- Auto-scroll to follow new content, but stops if user scrolls up (don't fight the user)
- Token-by-token insertion, not batched (batched feels laggy)

**Pitfalls to avoid:**
- Inserting raw text without markdown rendering (code blocks appear as plain text)
- Forcing scroll even when user has scrolled up to read
- Batch-inserting text (visual stutter)
- Cursor that continues blinking after generation completes

### 3 — Citation Display

How model-cited sources appear inline and in a reference list.

**Inline citation (footnote style):**
```
The Treaty of Westphalia was signed in 1648.[^1]

[^1]: Croxton, D. (1999). "The Peace of Westphalia of 1648"
```

**UI pattern:**
- Superscript number in the response text: `<sup><a href="#ref-1">[1]</a></sup>`
- Reference list below the response, collapsible if > 5 sources
- Each reference: title, source, date, [Open link ↗]
- Cited passages highlighted on hover over the reference number

**Pitfalls to avoid:**
- Inline URLs breaking the reading flow
- "Source: the internet" — sources must be specific
- Citations that don't link to the actual passage in the source document
- More than 3 inline citation styles (footnote, bracket, URL) in the same product

### 4 — Agent Action Log

Timeline of actions an agent has taken or is planning.

```
● Step 1  Search "recent AI papers" — 3 results              ✓ Done
● Step 2  Read paper: "Attention Is All You Need" (2017)      ✓ Done
◌ Step 3  Summarise findings                                  ◌ In progress
○ Step 4  Draft response                                      ○ Pending
```

**Required elements:**
- Step status: `done / in-progress / pending / failed`
- Tool name and arguments (human-readable, not raw JSON)
- Duration for completed steps
- Collapsible detail for steps with large outputs
- [Cancel] always visible while any step is in-progress

**Pitfalls to avoid:**
- Raw JSON tool calls in the UI (users see `{"tool": "search", "query": "..."}`)
- No way to stop the agent mid-run
- Steps that disappear on completion (users want to audit what happened)

### 5 — Uncertainty Indicator

Signals when the model's confidence is low.

**Visual pattern:**
- Amber border or left bar on the response container
- ⚠ icon + label: "Low confidence — verify this"
- Optional: confidence score if the model provides one
- Link to [Show sources] or [Check manually]

**Trigger conditions:**
- Model response contains hedging language ("I think", "I'm not certain", "approximately")
- Retrieved context confidence below threshold (in RAG pipelines)
- Response to question outside model knowledge cutoff

**Pitfalls to avoid:**
- Crying wolf: every response has an uncertainty badge (users stop reading them)
- Binary confident/uncertain (add a confidence scale when useful)
- Uncertainty signal with no action — always pair with a next step

### 6 — Empty State

The first view a user sees before any interaction.

**Anatomy:**
```
        [Illustration or icon — not clipart]

    What would you like to know about [topic]?

    ┌─────────────────┐  ┌─────────────────┐
    │ 💡 What is X?   │  │ 📋 Compare X/Y  │
    └─────────────────┘  └─────────────────┘
    ┌─────────────────┐  ┌─────────────────┐
    │ 🔍 How do I...? │  │ ✍ Help me draft │
    └─────────────────┘  └─────────────────┘

    [Prompt input]
```

**Non-negotiable:**
- At least 4 example prompts — clickable, not just displayed
- Example prompts should be task-specific (not generic "Ask me anything")
- Illustration conveys the feature's purpose, not generic "AI robot"
- Prompt input visible and focused from page load

## Rationalization Red Flags

These thoughts mean a generic component was used where an AI component was needed — stop:

- *"A regular textarea works for prompt input"* — until users discover Enter sends, there's no token counter, and there's no way to stop generation
- *"I'll add the streaming cursor later"* — streaming without a cursor reads as broken; the cursor is not polish, it is the streaming affordance
- *"Citations can just be links in the text"* — inline URLs break the reading flow; citations need a footnote system
- *"Empty state can be a placeholder"* — placeholder text is not an empty state; an empty state guides the user's first action

## Completion Statement Format

When ai-component-patterns is satisfied, state it like this:

```
AI components implemented.
Components in this feature: <list>

Prompt input: auto-resize ✓, Cmd+Enter to send ✓, [Stop] during generation ✓,
  aria-label ✓, token counter ✓
Streaming output: aria-live="polite" ✓, cursor aria-hidden ✓, 
  markdown rendered live ✓, auto-scroll respects user position ✓
[Other components with their required elements checked]
```

## Why This Matters

AI-native components have interaction requirements that emerge from the model's behaviour — streaming, uncertainty, multi-step execution — not from conventional UI patterns. A generic textarea has no concept of generation state. A generic text display has no concept of streaming. Using the right component from the start prevents a category of UX bugs that cannot be fixed by iterating on a wrong foundation.
