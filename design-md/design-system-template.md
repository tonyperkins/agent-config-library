# DESIGN.md

Design system instructions that AI coding agents can read and follow. Place this
at the project root (or in a `design/` directory) alongside CLAUDE.md.

## What this is
A machine-readable design system reference. Agents use this to produce UI that
matches your brand without you restating colors, spacing, and component rules
in every prompt.

## Brand
- Primary color: `[hex or token name]`
- Secondary color: `[hex or token name]`
- Accent color: `[hex or token name]`
- Font family: `[family, fallbacks]`
- Font sizes: `[scale, e.g. "12, 14, 16, 20, 24, 32, 48px"]`

## Spacing
- Base unit: `[e.g. 4px or 8px]`
- Scale: `[e.g. "4, 8, 12, 16, 24, 32, 48, 64"]`

## Components
- Buttons: `[variants, sizes, border radius]`
- Cards: `[padding, shadow, border radius]`
- Inputs: `[height, padding, border, focus state]`
- Navigation: `[layout, height, responsive behavior]`

## Layout
- Max content width: `[e.g. 1200px]`
- Breakpoints: `[e.g. "640, 768, 1024, 1280"]`
- Grid: `[columns, gap]`

## Tone
- [e.g. "Professional but approachable", "Minimal and direct"]

## References
- [Link to Figma file or design tokens JSON]
- [Link to component library docs]
