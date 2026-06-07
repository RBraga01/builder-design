# Changelog

All notable changes to builder-design are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
Versioning follows [Semantic Versioning](https://semver.org/).

---

## [1.0.0] — 2026-06-07

### Added

**8 skills:**
- `ai-states-required` — 7 required states for every AI feature touchpoint
- `design-before-code` — spec-first workflow: layout, states, copy, interactions
- `accessible-ai-output` — ARIA live regions, reading order, cognitive load
- `ai-component-patterns` — 6 AI-native components with required sub-components
- `prompt-ux-design` — input design, suggestion system, feedback loop, constraints
- `ai-output-design` — markdown rendering, typography, structured data, confidence signals
- `ai-onboarding-design` — capability communication, trust building, first win design
- `design-token-audit` — 5 token categories, AI-specific tokens, dark mode verification

**5 agents:**
- `ai-ui-designer` (Opus) — full AI component design, spec to token-compliant implementation
- `ux-critic` (Sonnet) — structured critique against all 5 skill areas, BLOCK/WARN/NOTE verdicts
- `state-designer` (Sonnet) — all 7 states mapped before component code is written
- `prompt-ux-designer` (Sonnet) — input pattern, suggestion system, feedback loop, constraints
- `accessibility-reviewer` (Sonnet) — ARIA, keyboard, contrast, cognitive load audit

**Infrastructure:**
- `install.sh` and `install.ps1` — sparse clone installer for both platforms
- `scripts/check_consistency.py` — version consistency across README, CLAUDE.md, AGENTS.md, CHANGELOG.md
- GitHub Actions: consistency check, release, PR labeler, branch cleanup, fork welcome, fork follow-up
- Full GitHub template set: bug report, feature request, PR template
- CONTRIBUTING.md, SECURITY.md, FUNDING.yml, dependabot.yml
