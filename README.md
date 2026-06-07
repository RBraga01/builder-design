# builder-design — AI UI Design Skills Pack v1.0.0

Your AI assistant will design the chat input as a plain textarea, skip the streaming cursor, hardcode `#3b82f6` in five components, and ship without a single designed error state.

**This pack makes that impossible.**

---

## The Problem

Generic UI patterns were not built for AI. A textarea has no concept of generation state. A div has no concept of streaming. Markdown rendered without a typography system is a wall of text. And hardcoded colours in AI components mean every rebrand is a multi-file migration.

Builder-design adds the design enforcement layer that AI feature UIs need — and that no general-purpose design system covers.

## What It Blocks

| Without builder-design | With builder-design |
|---|---|
| Streaming output has no cursor — looks broken | Streaming cursor required, `aria-hidden` from screen readers |
| Error state is a blank screen or generic toast | All 7 states designed before any component code |
| Prompt input is a fixed-height textarea | Auto-resize, Cmd+Enter, [Stop], token counter — or it doesn't ship |
| `#3b82f6` hardcoded in 6 components | Every colour, spacing, shadow references a token |
| No empty state — blank input, user abandons | 4+ clickable domain-specific examples, input focused on load |
| Screen reader announces every streaming token | `role="log" aria-live="polite" aria-atomic="false"` enforced |

## The 8 Skills

| Skill | What It Enforces |
|---|---|
| `ai-states-required` | All 7 states (Loading, Streaming, Success, Error, Partial, Uncertain, Empty) designed before code |
| `design-before-code` | Spec first: layout diagram, states, copy, interaction map — then code |
| `accessible-ai-output` | ARIA live regions, reading order, cognitive load for dynamic AI content |
| `ai-component-patterns` | 6 AI-native components with required sub-components — no generic substitutes |
| `prompt-ux-design` | Input pattern, suggestion system, feedback loop, history, constraints |
| `ai-output-design` | Markdown rendering stack, typography hierarchy, confidence signals, progressive disclosure |
| `ai-onboarding-design` | Capability communication, trust building, first win design — not just an empty input |
| `design-token-audit` | 5 token categories, AI-specific tokens, dark mode verification — zero hardcoded values |

## The 5 Agents

| Agent | Model | Role |
|---|---|---|
| `ai-ui-designer` | Opus | Full AI component design from spec to token-compliant implementation |
| `ux-critic` | Sonnet | Structured critique — BLOCK / WARN / NOTE verdicts, not suggestions |
| `state-designer` | Sonnet | Maps all 7 states before any component code is written |
| `prompt-ux-designer` | Sonnet | Prompt input, suggestion system, feedback loop, constraint design |
| `accessibility-reviewer` | Sonnet | ARIA, keyboard, contrast, cognitive load — accessibility audit before ship |

## How the Enforcement Works

Each skill has a **Completion Statement Format** — a literal code block that must be filled with real values. An agent cannot satisfy it with "looks good" or "all states are designed." It either has a state map at `design/ai-states/<feature>.md` or it doesn't. It either has a token count or it doesn't.

Example — `ai-states-required` completion:
```
States designed: 7/7
Feature: document-assistant
State map: design/ai-states/document-assistant.md ✓

Loading: skeleton animation, "Searching your documents..." ✓
Streaming: typing cursor (▋), [Stop] button, auto-scroll ✓
Success: response rendered, [Copy] [👍 👎] [Retry] ✓
Error: inline error, recovery action, input re-enabled ✓
Partial: truncation notice, [Continue] action ✓
Uncertain: amber left bar, "Low confidence — verify this" ✓
Empty: 4 example prompts, input focused ✓

Edge cases:
  Stream interrupted mid-word: partial token cleared, Error state shown ✓
  Empty string response: treated as Partial, not Success ✓
  Submit during generation: queued, shown after current completes ✓
```

## Install

### macOS / Linux
```bash
curl -fsSL https://raw.githubusercontent.com/RBraga01/builder-design/main/install.sh | bash
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/RBraga01/builder-design/main/install.ps1 | iex
```

### Manual
```bash
git clone --filter=blob:none --sparse https://github.com/RBraga01/builder-design.git
cd builder-design
git sparse-checkout set skills .claude/agents
cp -rn skills/ /path/to/your/project/
cp -rn .claude/ /path/to/your/project/
```

## Works Standalone or With A Team

builder-design is independent. Use it with any Claude project:

```bash
# Standalone
cp -r skills/ .claude/agents/ your-project/

# With A Team
# Installs alongside A Team's 25 agents and 18 workflow skills
```

If you use [A Team](https://github.com/RBraga01/a-team), builder-design adds the AI design enforcement layer that the engineering team doesn't cover.

---

MIT License — Ricardo Romão Marques Braga
