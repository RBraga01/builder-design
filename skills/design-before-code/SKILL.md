---
name: design-before-code
description: Use before implementing any new AI feature UI component. Requires a written shape/spec — layout, states, copy, interactions — before a single line of implementation code is written. Blocks "I'll design it as I build it" completions.
---

# Design Before Code

## The Law

```
CODE WRITTEN WITHOUT A SPEC IS ALWAYS A PROTOTYPE.
"I'll design it as I build it" produces UI shaped by what was easy to code — not by what users need.
A written layout, state definitions, final copy, and interaction map IS a spec.
```

## When to Use

Trigger before:
- Implementing any new AI feature UI component
- Refactoring a component that changes its interaction model
- Adding a new page or major section to an AI product
- Implementing the output of an agent or multi-step AI workflow

## When NOT to Use

- Hotfixes to existing, already-designed components (wording changes, colour tweaks)
- Backend-only changes with no UI surface
- Prototypes explicitly scoped as throwaway (label them as such)

## The Spec Format

A spec does not need to be a Figma file. It needs to answer four questions:

### 1 — Layout

What is the visual structure? Describe it in words or ASCII:

```
┌─────────────────────────────────┐
│ [Avatar] User message           │
│                                 │
│          AI response  [Avatar]  │
│          ─ ─ streaming ─ ─      │
│                                 │
│ [Prompt input ___________] [▶]  │
└─────────────────────────────────┘
```

Note: column widths, alignment, responsive behaviour (stacks on mobile? collapses?), max-width constraints.

### 2 — States

Which states does this component have? (See `ai-states-required` for the full list.) For each state, note the visual difference.

```
| State    | Visual change                          |
|----------|----------------------------------------|
| Loading  | Response area shows streaming cursor   |
| Error    | Red border, inline error copy          |
| Success  | Full text, feedback buttons appear     |
```

### 3 — Copy

Write the actual copy for every text element — not "label here" but the final words.

```
Placeholder:  "Ask anything about this document…"
Error:        "Something went wrong. Try again."
Empty:        "No messages yet. Start by asking a question."
Loading:      "Thinking…"
```

### 4 — Interactions

What can the user do, and what happens?

```
Send message → POST /api/chat → show loading → stream response
Stop generation → abort stream → show partial + [Continue] button
Retry → resend last message → loading state
Copy response → clipboard → toast "Copied"
Thumbs down → open feedback modal
```

## The Process

### Step 1 — Write the Spec

Create `design/specs/<component-name>.md` with the four sections above. Takes 15–30 minutes. Saves 4 hours of back-and-forth after implementation.

### Step 2 — Review for Completeness

Before starting code, verify the spec answers:
- [ ] Does every state from `ai-states-required` have a visual treatment?
- [ ] Is every text element written out (no placeholder copy)?
- [ ] Is the responsive behaviour defined?
- [ ] Is every user action mapped to a consequence?
- [ ] Are edge cases noted (long text, empty response, simultaneous requests)?

### Step 3 — Implement Against the Spec

Code to the spec, not alongside it. If implementation reveals a gap in the spec, stop and update the spec before continuing. The spec is the source of truth.

### Step 4 — Review Implementation Against Spec

Before marking the PR ready, check the implementation against each spec section. A diff between spec and implementation is either a spec update (conscious decision) or a regression.

## Rationalization Red Flags

These thoughts mean no spec exists — stop:

- *"I know what it should look like"* — then writing it down takes 15 minutes and saves hours of review cycles
- *"It's a simple component"* — simple components have 7 AI states, 4 interactions, and 3 edge cases
- *"I'll spec it after implementation"* — post-implementation specs document what was built, not what should have been built; they have no enforcement value
- *"Design and code can happen simultaneously"* — they can; the spec is what keeps them aligned when they diverge, which they always do
- *"We're moving fast"* — you are; a spec keeps you from spending that speed redoing work

## Completion Statement Format

When design-before-code is satisfied, state it like this:

```
Spec written.
Component: <name>
File: design/specs/<component-name>.md ✓

Layout: <described — responsive behaviour noted> ✓
States: <N states documented — all from ai-states-required covered> ✓
Copy: <all text elements written — no placeholder copy> ✓
Interactions: <all user actions mapped to consequences> ✓
Edge cases noted: <long text / empty response / simultaneous submit> ✓

Ready to implement.
```

## Why This Matters

UI built without a spec is designed by the path of least resistance through the code, not by what users need. AI product UIs are especially vulnerable: the model's output is unpredictable in length, format, and latency. Without a spec, every edge case the model produces becomes a visual surprise the developer handles ad hoc — inconsistently, incompletely, and under time pressure.
