---
name: ai-onboarding-design
description: Use when designing first-run flows and empty states for AI features. AI onboarding has specific requirements — model capability communication, trust building, and graceful degradation when the model doesn't know — that generic onboarding patterns miss.
---

# AI Onboarding Design

## The Law

```
AN AI FEATURE WITHOUT DESIGNED ONBOARDING FAILS ITS MOST IMPORTANT USERS FIRST.
First-time users don't know what the model can do, what to ask, or whether to trust it.
"They'll figure it out" loses users before they discover the feature's value.
Capability communication + trust signals + first-win design IS AI onboarding.
```

## When to Use

Trigger when:
- Designing the first-run experience for any AI feature
- Designing empty states for a chat, AI assistant, or agent interface
- Adding AI capabilities to an existing product for the first time
- Reviewing whether existing AI onboarding communicates capability and builds trust

## When NOT to Use

- Features with returning users who already know the interface (post-onboarding flows)
- Internal developer tools where the audience already knows the model's capabilities

## The Three Onboarding Obligations

### 1 — Capability Communication

Users cannot use what they don't know exists. The empty state must teach the model's capabilities.

**What to show:**
- 4–6 example prompts, specific to this feature's domain
- Example prompts are clickable and submit immediately
- Prompts cover: simple query, complex analysis, creative use, edge of capability

```
What can I help you with?

┌─────────────────────────────┐  ┌──────────────────────────────┐
│ Summarise this contract     │  │ Compare these two proposals   │
└─────────────────────────────┘  └──────────────────────────────┘
┌─────────────────────────────┐  ┌──────────────────────────────┐
│ What are the key risks?     │  │ Draft an email about...       │
└─────────────────────────────┘  └──────────────────────────────┘
```

**What not to show:**
- "Ask me anything!" — too vague; users don't know what "anything" means for this feature
- Examples outside the model's actual capability for this use case
- More than 6 examples — choice paralysis

### 2 — Trust Building

AI features require more trust than deterministic features. Users don't know:
- Where the data comes from
- Whether the model makes things up
- What happens to their input

Address these before the user asks:

**Trust signals:**
- Source attribution visible from the first response (not just on request)
- Model capability boundary stated: "I answer questions about [your documents / your codebase / this topic]. I don't have access to the internet."
- Data handling: "Your conversations are [not stored / stored for X days / used to improve...]"
- Uncertainty disclosure: "I'll tell you when I'm not sure" — demonstrate it in the first response if possible

**First response design:**
The first response a user receives is their trust calibration moment. Design it:
- Should be for a low-stakes, high-accuracy example
- Should include a source citation even if the example doesn't require it (teaches the pattern)
- Should be fast (< 2s to first token if possible)
- Length: medium (100–200 words) — not so short it feels dismissive, not so long it's overwhelming

### 3 — First Win Design

The user's first successful interaction determines whether they return.

**Design the first win:**
1. What is the simplest, highest-value use of this feature?
2. How do you get the user to attempt it on their first visit?
3. What does a successful response to that use look like?

Then build the onboarding toward that specific first win:
- Empty state examples point toward the first win use case
- The first response to the recommended example is a showcase response
- After the first successful response: show a "Next, try…" suggestion

## The Onboarding State Machine

```
[First visit]
     ↓
[Empty state — capability communication + trust signals]
     ↓
[User types or clicks example]
     ↓
[Loading state — fast first-token < 2s]
     ↓
[First response — showcase quality, with citation]
     ↓
[Post-first-response — feedback prompt + "Next, try..." suggestion]
     ↓
[Established user — regular empty state without capability education]
```

After the first successful interaction, the empty state can be simplified — don't show capability education on every visit.

## The "Model Doesn't Know" Moment

Every AI feature will fail to answer a user's question at some point. Design for it:

```
I don't have information about [topic] in [your documents / this knowledge base].

You could try:
→ [Rephrase your question]
→ [Search in the full document set]
→ [Ask about something else]
```

- Never return a blank response
- Never return a raw "I don't know"
- Always offer a next action
- If the topic is outside the model's scope, say so explicitly (not "I couldn't find that")

## The Process

### Step 1 — Define the First Win

Before designing any UI, answer: what is the simplest, highest-value thing a first-time user can do with this feature? Everything else — the empty state, the example prompts, the first response — is designed to deliver that win.

### Step 2 — Write the Capability Boundary

One sentence: "I answer questions about [X]. I don't [Y]." This goes in the empty state and in the first response. Write it before designing any UI — it defines the scope that every example prompt must stay within.

### Step 3 — Design the Empty State

4–6 example prompts, all specific, all clickable, all within the capability boundary. Write the actual prompt text. "What are the key risks in this contract?" is a prompt. "Ask me something" is not.

### Step 4 — Design the First Response

The first response to the most likely example prompt should be designed — not left entirely to the model. Know what a showcase response looks like for this feature. If the model's actual first response would undermine trust, this is a product design problem to solve now, not after launch.

### Step 5 — Design the Trust Signals

Four required: source attribution visible from the first response, capability boundary stated, data handling disclosed, uncertainty disclosure present. Check all four.

### Step 6 — Design the "Model Doesn't Know" State

Write the copy for when the model can't answer. "I don't have information about [topic] in [source]." + at least one next action. Never leave the user at a dead end.

### Step 7 — Define the Return Visit Simplification

After the first successful interaction, what changes? The capability education in the empty state should be simplified or removed for returning users. Define the trigger (first response received, explicit "got it", session count) and the simplified state.

## Rationalization Red Flags

These thoughts mean onboarding was not designed — stop:

- *"Users know how to use AI"* — they know ChatGPT; they don't know what your specific feature can do with your specific data
- *"The empty state can be a blank input"* — blank inputs communicate nothing; they leave first-time users with no starting point
- *"We'll add example prompts after we see what users ask"* — you'll add them after you've already lost the users who never came back
- *"Trust signals are marketing language"* — "I answer questions about your contracts" is not marketing; it is the capability boundary that prevents users from asking off-topic questions and blaming the product when the answer is wrong

## Completion Statement Format

When ai-onboarding-design is satisfied, state it like this:

```
Onboarding designed.
Feature: <name>

Capability communication:
  Example prompts: <N> prompts, specific to domain, clickable ✓
  Coverage: simple query / complex analysis / creative / edge case ✓

Trust signals:
  Source attribution: visible from first response ✓
  Capability boundary: stated in empty state ("I answer questions about...") ✓
  Data handling: disclosed ✓
  Uncertainty disclosure: "I'll tell you when I'm not sure" ✓

First win:
  Target first win: <description> ✓
  Empty state points toward it ✓
  First response is showcase quality ✓
  Post-response suggestion: "Next, try..." ✓

"Model doesn't know" state: designed with next-action options ✓
Return visit: simplified empty state (no repeated capability education) ✓
```

## Why This Matters

First-time users of an AI feature have no intuition about what the model can do, how accurate it is, or whether their input is safe to submit. Without onboarding design, they probe by trial and error, encounter limitations before they encounter value, and churn before the feature has a chance to demonstrate its usefulness. The onboarding is the feature's first impression — and first impressions with AI products are unusually hard to recover.
