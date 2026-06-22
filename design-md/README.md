# DESIGN.md

Design system config for AI coding agents. This is a new config type that makes
design systems agent-readable - agents can read this file and produce UI that
matches your brand guidelines without you restating design rules in every prompt.

## Why this exists

The community is converging on DESIGN.md as a standard for making design systems
machine-readable. 73+ DESIGN.md files from brands like Apple, Google, and Stripe
have been shared as examples.

## What to put here

- Color tokens (primary, secondary, accent, semantic colors)
- Typography (font families, sizes, weights, line heights)
- Spacing scale (base unit and multiplier steps)
- Component specs (buttons, cards, inputs, navigation)
- Layout rules (max width, breakpoints, grid)
- Brand tone and voice

## How agents use it

Place DESIGN.md at your project root. Agents read it alongside CLAUDE.md when
generating or modifying UI code. For monorepos, you can place subsystem-specific
DESIGN.md files in `apps/web/DESIGN.md`, etc.

## Template

See `design-system-template.md` for a fill-in-the-blanks template.
