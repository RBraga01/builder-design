# Contributing to builder-design

## What Contributions Are Accepted

- **New skills** for AI UI design patterns not covered by the current 8
- **Agent improvements** with stronger enforcement or better output formats
- **Bug fixes** in existing skills (incorrect patterns, outdated ARIA specs)
- **Infrastructure improvements** (install scripts, CI)

## What Is Not Accepted

- Skills for general frontend design (typography, colour theory, motion) — use [impeccable](https://github.com/pbakaus/impeccable) for those
- Skills without a Completion Statement Format
- Agents that don't produce a PASS / BLOCK verdict

## Skill Quality Bar

Every new skill must have:

1. **YAML frontmatter** — `name` and `description` fields
2. **The Law** — ALL CAPS code block, 3-part format:
   - What cannot be done without it
   - What doesn't count as doing it
   - What does count (the definition)
3. **When to Use** — specific trigger conditions
4. **When NOT to Use** — at least 2 exclusions
5. **The Process** — numbered steps, no hand-waving
6. **Rationalization Red Flags** — *italic "developer excuse"* + rebuttal with consequences
7. **Completion Statement Format** — literal fillable code block with real counts
8. **Why This Matters** — the compound cost of skipping this skill

## Pull Request Process

1. One skill or agent per PR
2. PR title: `feat: add <skill-name> skill` or `fix: <skill-name> — <what was wrong>`
3. Include the filled-in Completion Statement Format in the PR description
4. All CI checks must pass

## Reporting Issues

Use GitHub Issues. For skill gaps (patterns not covered), use the Feature Request template. For incorrect patterns, use the Bug Report template.
