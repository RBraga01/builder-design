---
name: ai-states-required
description: Use before writing any code for an AI feature's UI. All 7 states must be designed and documented before implementation begins. Blocks "we'll add loading states later" completions.
---

# AI States Required

## The Law

```
AN AI FEATURE WITHOUT DESIGNED STATES IS HALF A FEATURE.
"We'll add error states later" means users see broken UI in production.
"The happy path looks great" is not a UI design — it is a demo.
All 7 states designed, documented, and approved IS a complete AI feature design.
```

## The 7 Required States

Every AI feature touchpoint must have a designed state for each:

| State | When It Appears | What Users Need |
|---|---|---|
| **Loading** | Request sent, waiting for first token | Progress signal, estimated wait, cancel option |
| **Streaming** | Tokens arriving, response building | Readable partial content, clear "generating" signal |
| **Success** | Generation complete, full response available | Result, confidence signal, actions (copy, retry, share) |
| **Error** | API failure, timeout, server error | Human error message, recovery action, no raw stack trace |
| **Partial** | Model answered but incompletely | Clear indication of incompleteness, option to continue |
| **Uncertain** | Low confidence, hedged response | Uncertainty signal, source citation, human review option |
| **Empty** | No input yet / no history / first run | Guidance, examples, prompt suggestions — not a blank void |

## When to Use

Trigger before:
- Any PR that adds a new AI-powered UI feature
- Any PR that adds a new model call with user-visible output
- Designing a new agent interface or chat UI
- Adding AI capabilities to an existing feature

## When NOT to Use

- Background AI jobs with no user-facing output (batch processing, background classification)
- Developer-only tooling where no end user sees the output

## The Process

### Step 1 — List Every AI Touchpoint

Map every place the user will see model output in this feature:
- Main response area
- Any inline predictions (autocomplete, suggestions)
- Status indicators (sidebar, header badges)
- Any secondary outputs (citations, related items, follow-up questions)

Each touchpoint needs its own 7-state design.

### Step 2 — Design Each State

For each state, define:
- **Visual treatment** — skeleton / spinner / streaming cursor / error icon / empty illustration
- **Copy** — what the UI says in this state (not placeholder text, actual final copy)
- **Actions** — what the user can do from this state
- **Transition** — how it moves to the next state

```
State: Error
Visual: Red border on output area, error icon (⚠), inline message
Copy: "Something went wrong generating your response. Try again or refresh."
Actions: [Try again] [Dismiss]
Transition: Retry → Loading state; Dismiss → Empty state
```

### Step 3 — Document in a State Map

Create `design/ai-states/<feature-name>.md` with the state map:

```markdown
## Feature: <name>
### Touchpoint: <main output area>

| State | Visual | Copy | Actions | Transition |
|---|---|---|---|---|
| Loading | Skeleton (3 lines) | "Generating..." | [Cancel] | Cancel → Empty; First token → Streaming |
| Streaming | Streaming cursor, partial text | Live text | [Stop] | Complete → Success; Error → Error |
| Success | Full response | — | [Copy] [Retry] [👍 👎] | Retry → Loading |
| Error | Red border, inline message | "Something went wrong. Try again." | [Try again] | → Loading |
| Partial | Dashed border, "▾ Response cut off" | "Response was cut off. Continue?" | [Continue] [Accept] | Continue → Loading |
| Uncertain | Amber border, ⚠ badge | "Low confidence — verify this." | [Show sources] | — |
| Empty | Prompt suggestions, example queries | "Ask anything about X…" | [Example 1] [Example 2] | User types → Loading |
```

### Step 4 — Review the Edge Cases

Before sign-off, verify each of these works:
- What if the stream is interrupted mid-word?
- What if the error message from the API is user-readable vs. a raw 500?
- What if the model returns an empty string?
- What if the response is extremely long (>2000 words)?
- What if the user submits again before the first response finishes?

## Rationalization Red Flags

These thoughts mean states were not designed — stop:

- *"We'll add error states in a follow-up"* — follow-up PRs for error states ship 3 weeks late, after the first 3am incident
- *"The happy path is what matters for the demo"* — users encounter every state; you only rehearsed one
- *"Just show a spinner"* — a spinner with no copy, no cancel, and no timeout handling is not a loading state
- *"The streaming state is just the loading state with text"* — streaming and loading have different affordances; conflating them produces UI that feels broken
- *"Empty state can be a blank screen with a text input"* — blank screens communicate nothing; empty states are onboarding moments

## Completion Statement Format

When ai-states-required is satisfied, state it like this:

```
AI states designed.
Feature: <name>
Touchpoints covered: <N>
State map: design/ai-states/<feature>.md ✓

All 7 states documented for each touchpoint:
  Loading: <visual treatment + copy> ✓
  Streaming: <visual treatment + copy> ✓
  Success: <visual treatment + copy> ✓
  Error: <visual treatment + copy + recovery action> ✓
  Partial: <treatment + continuation option> ✓
  Uncertain: <confidence signal + citation path> ✓
  Empty: <prompt guidance + examples> ✓

Edge cases reviewed: stream interruption, empty response, duplicate submit ✓
```

## Why This Matters

AI features fail visually in ways deterministic software does not. A form either submits or fails. An LLM call can stream, stall, truncate, hallucinate, refuse, or produce an empty response — and users see all of these. Designing only the success state means every other state ships as broken UI.
