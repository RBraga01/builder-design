# builder-design — AI UI Design Skills Pack v1.0.0

## What This Pack Is

8 skills and 5 agents that enforce design quality for AI feature UIs. Every skill has a Completion Statement Format — a literal code block that must be filled with real values before work is considered done.

## Skills

| Skill | Trigger |
|---|---|
| `ai-states-required` | Before any AI feature component code is written |
| `design-before-code` | Before any component implementation begins |
| `accessible-ai-output` | Before any AI output rendering ships |
| `ai-component-patterns` | When implementing any of the 6 AI-native components |
| `prompt-ux-design` | Before designing any AI prompt input |
| `ai-output-design` | When designing AI response rendering |
| `ai-onboarding-design` | When designing first-run or empty state for an AI feature |
| `design-token-audit` | Before merging any AI feature UI component |

## Agents

| Agent | Model | Use When |
|---|---|---|
| `ai-ui-designer` | Opus | Designing a new AI component from scratch |
| `ux-critic` | Sonnet | Reviewing any AI feature UI before ship |
| `state-designer` | Sonnet | Mapping states for a new AI feature |
| `prompt-ux-designer` | Sonnet | Designing the prompt input experience |
| `accessibility-reviewer` | Sonnet | Accessibility audit before ship |

## Enforcement Model

Every skill's Completion Statement Format must be filled with real values:
- Real component names
- Real file paths
- Real counts (not "all states designed" — "7/7 states designed")
- Real verdicts (PASS / BLOCK — not "looks good")

## File Conventions

- State maps: `design/ai-states/<feature>.md`
- Component specs: `design/specs/<feature>.md`
- Prompt UX specs: `design/specs/<feature>-prompt-ux.md`
- Safety/accessibility reviews: `design/reviews/<feature>/<date>.md`

## Quality Bar

A component is not complete until:
1. Spec exists at `design/specs/<feature>.md`
2. State map exists at `design/ai-states/<feature>.md`
3. All AI-native component patterns satisfied
4. Zero hardcoded values (design-token-audit passes)
5. Accessibility review: no BLOCK issues
6. UX critique: no BLOCK issues

## Version

Current: 1.0.0 — see CHANGELOG.md for history.
