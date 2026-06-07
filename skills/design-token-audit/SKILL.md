---
name: design-token-audit
description: Use before any AI feature UI lands in production. Every colour, spacing value, typography, shadow, and border in AI components must reference design tokens — no hardcoded values. Blocks "I'll align with the design system later" completions.
---

# Design Token Audit

## The Law

```
HARDCODED VALUES IN AI COMPONENTS ARE DESIGN SYSTEM DEBT.
#3b82f6 in a component is not blue — it is a value that will diverge from the theme.
"I'll align with the design system later" ships technical debt that compounds at every new component.
All values referencing tokens IS a token-compliant component.
```

## When to Use

Trigger before:
- Merging any PR that introduces new AI feature UI components
- Adding new visual styles (colours, spacing, shadows) to existing components
- Launching a new AI feature into a product with an existing design system
- Conducting a design system health check

## When NOT to Use

- New products with no design system yet (define tokens first, then this skill applies)
- Prototypes explicitly scoped as throwaway

## The Token Categories

Every AI component must reference tokens for all five categories:

### 1 — Colour Tokens

```css
/* ✗ Hardcoded — fails audit */
color: #3b82f6;
background: rgba(239, 68, 68, 0.1);
border: 1px solid #e5e7eb;

/* ✓ Token-compliant — passes audit */
color: var(--color-primary);
background: var(--color-error-subtle);
border: 1px solid var(--color-border);
```

**AI-specific colour tokens that must exist:**
```css
--color-ai-response-bg       /* Background for AI response containers */
--color-ai-streaming         /* Streaming cursor colour */
--color-ai-uncertain         /* Uncertainty indicator (amber family) */
--color-ai-citation          /* Citation highlight colour */
--color-ai-error             /* AI-specific error (may differ from system error) */
```

### 2 — Spacing Tokens

```css
/* ✗ Fails */
padding: 12px 16px;
gap: 8px;

/* ✓ Passes */
padding: var(--space-3) var(--space-4);
gap: var(--space-2);
```

All spacing must follow a scale (4px base, or 8px base). Arbitrary values (`13px`, `22px`, `37px`) are automatic failures.

### 3 — Typography Tokens

```css
/* ✗ Fails */
font-size: 14px;
font-weight: 500;
line-height: 1.6;

/* ✓ Passes */
font-size: var(--text-sm);
font-weight: var(--font-medium);
line-height: var(--leading-relaxed);
```

### 4 — Shadow and Elevation Tokens

```css
/* ✗ Fails */
box-shadow: 0 4px 24px rgba(0,0,0,0.4);

/* ✓ Passes */
box-shadow: var(--shadow-md);
```

### 5 — Border Radius Tokens

```css
/* ✗ Fails */
border-radius: 8px;

/* ✓ Passes */
border-radius: var(--radius-sm);
```

## The Audit Process

### Step 1 — Extract All Values

For each AI component file, extract every hardcoded CSS value:

```bash
# Find hardcoded colours (hex, rgb, hsl, oklch)
grep -Ern "(#[0-9a-fA-F]{3,8}|rgba?\(|hsl[a]?\(|oklch\()" src/components/ai/

# Find hardcoded spacing (px, rem not using var())
grep -Ern "[0-9]+px|[0-9]+\.?[0-9]*rem" src/components/ai/ | grep -v "var(--"

# Find hardcoded font sizes
grep -Ern "font-size:\s*[0-9]" src/components/ai/
```

### Step 2 — Classify Each Value

For each hardcoded value found:
- **Map to existing token**: `#3b82f6` → `var(--color-primary)` — replace
- **New token needed**: value not in system → define the token, then reference it
- **Exception**: animation `transition` values may not need tokens in all systems — document the exception

### Step 3 — Add Missing AI-Specific Tokens

If the design system doesn't have `--color-ai-response-bg`, `--color-ai-uncertain`, etc., define them now — not as hardcoded values in the component, but as tokens in the system's token file.

### Step 4 — Verify Dark Mode / Theming

All tokens must work in both light and dark mode (or the product's theme variants). AI-specific tokens are especially prone to dark mode failures — `--color-ai-uncertain` amber that works in light mode may be illegible in dark mode.

```css
:root {
  --color-ai-uncertain: oklch(75% 0.15 85);  /* Amber, light mode */
}
[data-theme="dark"] {
  --color-ai-uncertain: oklch(80% 0.18 85);  /* Brighter for dark mode */
}
```

## Rationalization Red Flags

These thoughts mean tokens were not used — stop:

- *"It's just a one-off component"* — one-off components become the pattern every other developer copies
- *"I'll align with the design system later"* — later becomes the next 40 components that also hardcode the same value, and then a migration sprint
- *"The design system doesn't have this token yet"* — then define the token now; that is what this skill requires
- *"It's close enough to the existing blue"* — "close enough" is visual debt that manifests as misaligned brand colours at scale

## Completion Statement Format

When design-token-audit is satisfied, state it like this:

```
Token audit complete.
Components audited: <N>

Hardcoded values found: <N>
  Mapped to existing tokens: <N>
  New tokens defined: <N> — <list: --color-ai-response-bg, etc.>
  Documented exceptions: <N> (e.g. transition durations)

All 5 categories compliant:
  Colour ✓  |  Spacing ✓  |  Typography ✓  |  Shadow ✓  |  Border radius ✓

Dark mode / theming: AI-specific tokens verified in both modes ✓
Zero hardcoded values remaining ✓
```

## Why This Matters

AI feature components are often built under time pressure, outside the normal design system workflow. Hardcoded values in these components compound: each new AI component copies the pattern, the design system drifts from the product, and a theme change or rebrand requires editing every component individually instead of updating three token values.
