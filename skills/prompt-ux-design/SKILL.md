---
name: prompt-ux-design
description: Use when designing the user-facing prompt experience for any AI feature. Covers input design, suggestion patterns, history, feedback signals, and the interaction model between user intent and model execution.
---

# Prompt UX Design

## The Law

```
THE PROMPT INPUT IS THE PRODUCT INTERFACE FOR AN AI FEATURE.
"It's just a text box" ships an input with no suggestions, no state feedback, and no token limit — users probe the model by trial and error until they give up.
Input design + suggestion system + 6-state feedback loop + constraints IS a prompt UX.
```

## When to Use

Trigger when:
- Designing the user-facing input for any AI feature
- Adding a chat or conversational interface
- Designing inline AI suggestions (autocomplete, copilot-style)
- Designing an agent invocation interface (slash commands, @ mentions)
- Reviewing whether an existing prompt input meets production standards

## When NOT to Use

- API-only interfaces with no user-facing input
- Admin / developer tools where power users are the only audience (simplify; don't over-design)

## The Five Prompt UX Dimensions

### 1 — Input Design

The physical input must match the expected interaction pattern:

| Pattern | Use When | Input Type |
|---|---|---|
| Short query | Single-question answers, search | Single-line input, auto-submit on Enter |
| Multi-line | Document drafting, detailed prompts | Auto-resize textarea, Cmd+Enter to send |
| Conversational | Chat, back-and-forth dialogue | Textarea + history above |
| Command | Agent invocation, slash commands | Input with `@` / `/` trigger detection |
| Constrained | Structured data entry, forms | Templated input with field hints |

Never default to multi-line when single-line is appropriate. Never use a fixed-height textarea.

### 2 — Suggestion System

Users don't know what the model is good at. Suggestions teach the interaction model.

**Types:**
- **Example prompts** — shown in the empty state; clickable, task-specific
- **Autocomplete suggestions** — appear as the user types (ghost text or dropdown)
- **Refinement suggestions** — shown after a response ("Try asking: follow-up 1 / follow-up 2")
- **Slash commands** — `/summarise`, `/translate`, `/explain` — explicit capability menu

**Rules:**
- Example prompts must be specific to the user's context, not generic
- Suggestions appear within 150ms of trigger or not at all (latency kills trust)
- Maximum 4–5 suggestions at once; more creates choice paralysis
- Suggestions are dismissible by `Escape`

### 3 — History and Context

In conversational interfaces:

- **Thread continuity**: show the conversation history above the input; the user can see what the model knows
- **Context limit indicator**: show when the conversation is approaching the context limit ("3 messages before earlier context is forgotten")
- **Clear thread**: explicit "New conversation" button — never auto-clear without warning
- **Edit previous messages**: allow re-prompting from any point in the conversation; show "Regenerated from message N" in the response

### 4 — Feedback Signals

The user must know the state of their request at all times:

```
Typing        → Normal input, send button active
Submitting    → Input locked, [Stop] replaces [Send], "Thinking…" status
Streaming     → Input unlocked for new message, "Generating…" + cursor
Complete      → [👍 👎] feedback, [Copy], [Retry], input re-focused
Error         → Error message inline, input re-activated, send re-enabled
```

Response feedback (👍 👎 or rating) must be:
- Non-blocking — doesn't interrupt the user flow
- Persistent — feedback submitted even if user navigates away
- Optional — never required to proceed

### 5 — Input Constraints and Guardrails

- **Token limit**: visible counter; soft warning at 80%, hard stop at 100%
- **Content validation**: before submit, check for empty input, whitespace-only, or inputs that will definitely fail (e.g., image prompt when model doesn't support images)
- **Rate limiting UI**: if the user is rate limited, show a clear message and time until reset — not a generic "Something went wrong"
- **Character minimum**: if the model performs poorly on very short inputs, communicate the minimum ("Add more detail for a better response")

## The Process

### Step 1 — Choose the Input Pattern

From the table in Dimension 1, select the pattern that matches the interaction model. Write it in the spec (see `design-before-code`).

### Step 2 — Design the Suggestion System

Define: what suggestions appear at empty state, what triggers autocomplete, whether refinement suggestions are shown, and which slash commands exist.

### Step 3 — Map the Feedback Loop

Write out the state machine for the input: idle → typing → submitted → streaming → complete → feedback. Each state has a visual treatment (see `ai-states-required`).

### Step 4 — Define Constraints

Specify: token limit, validation rules, rate limiting UX, and minimum input requirements.

## Rationalization Red Flags

These thoughts mean prompt UX was not designed — stop:

- *"It's just a text box"* — the input is where the user forms and submits their entire intent; it is the product
- *"Users know how to use a chat interface"* — they know ChatGPT's interface; your product is not ChatGPT
- *"We'll add suggestions in v2"* — v1 without suggestions means users probe by trial and error until they find what the model can do
- *"Feedback buttons are a nice-to-have"* — feedback is how you learn which responses the model gets wrong at scale

## Completion Statement Format

When prompt-ux-design is satisfied, state it like this:

```
Prompt UX designed.
Input pattern: <single-line / multi-line / conversational / command>
Reason: <one sentence>

Suggestion system:
  Example prompts: N — written out (e.g. "Summarise this contract", "What are the key risks?")
  Autocomplete: yes/no / Refinements: yes/no / Slash commands: yes/no
History: <thread display / context limit indicator / clear button>
Feedback loop: idle → typing → submitted → streaming → complete → feedback (all states mapped ✓)
Constraints: token limit=N (counter at 80%) / validation rules / rate limit UX ✓

Documented in: design/specs/<feature>.md ✓
```

## Why This Matters

The prompt input is the primary interface for every AI feature. Users who can't figure out what to ask, don't know whether their message was sent, can't stop a runaway generation, or can't tell the model it was wrong — those users churn. The prompt UX is not an input field; it is the entire interaction model made visible.
