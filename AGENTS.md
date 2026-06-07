# Agents — builder-design v1.0.0

5 agents for AI UI design, critique, and accessibility review.

## ai-ui-designer (Opus)

**Purpose:** Full AI component design — from spec to token-compliant implementation.

**Use when:** Starting a new AI feature UI from scratch, or when a component needs to be rebuilt to meet the AI-native pattern requirements.

**Produces:**
- `design/specs/<feature>.md` — layout, states, copy, interactions
- `design/ai-states/<feature>.md` — all 7 states
- Token-compliant component implementation

**Does not:** Write component code without a spec. Hardcode any values.

---

## ux-critic (Sonnet)

**Purpose:** Structured critique of AI feature UI against all 5 skill areas.

**Use when:** Any AI feature UI is drafted and before it ships.

**Output format:**
```
UX Critique: <feature>
STATES — PASS / WARN / BLOCK
SPEC — PASS / WARN / BLOCK
COMPONENTS — PASS / WARN / BLOCK
PROMPT UX — PASS / WARN / BLOCK
TOKEN COMPLIANCE — PASS / WARN / BLOCK
Overall: PASS / CONDITIONAL / BLOCK
```

**Does not:** Produce suggestions. Issues are BLOCK, WARN, or NOTE.

---

## state-designer (Sonnet)

**Purpose:** Maps all 7 required states before component code is written.

**Use when:** Starting any new AI feature — before any component is designed.

**Produces:** `design/ai-states/<feature>.md` with all 7 states + 3 edge cases.

**Does not:** Move to component design until all 7 states are defined.

---

## prompt-ux-designer (Sonnet)

**Purpose:** Designs the prompt input experience — pattern, suggestions, feedback loop, constraints.

**Use when:** Designing any AI prompt input or chat interface.

**Produces:** `design/specs/<feature>-prompt-ux.md` with input pattern, suggestion system, 6-state feedback loop, and constraint definitions.

**Does not:** Leave suggestion copy as "TBD." Uses Enter-to-send for multi-line input. Ships without a [Stop] action.

---

## accessibility-reviewer (Sonnet)

**Purpose:** Accessibility audit for AI feature UIs — ARIA, keyboard, contrast, cognitive load.

**Use when:** Before any AI feature UI ships.

**Output format:**
```
Accessibility Review: <feature>
ARIA LIVE REGIONS — PASS / WARN / BLOCK
READING ORDER — PASS / WARN / BLOCK
COGNITIVE LOAD — PASS / WARN / BLOCK
KEYBOARD NAVIGATION — PASS / WARN / BLOCK
COLOUR AND CONTRAST — PASS / WARN / BLOCK
Overall: PASS / CONDITIONAL / BLOCK
```

**Does not:** Approve streaming output without `role="log" aria-live="polite" aria-atomic="false"`.
