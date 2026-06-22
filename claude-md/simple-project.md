# Project: [name]

## What this is
[1-2 sentences: purpose, not implementation. Claude can't infer business intent from code.]

## Stack
- [Language/framework + version, e.g. "Next.js 15, TypeScript 5.6"]
- [Key libraries that matter for how code should be written, e.g. "Zustand for state, not Redux"]

## Commands
- Test: `npm test`
- Lint: `npm run lint`
- Dev server: `npm run dev`
- Build: `npm run build`

## Architecture pointers
- [Where the entry point is, where business logic lives, where tests go]
- [e.g. "src/lib/ is shared utilities, src/api/ is route handlers"]

## Conventions
- See `.claude/rules/` for code style, workflow, and dependency rules
- See `.claude/skills/` for available slash commands (/spec, /plan, /review, /debug, /test-gen, /ship)
- [Branch naming, commit message format, PR requirements if any]

## IMPORTANT
- [Reserve this marker for 1-2 truly critical rules, e.g. "IMPORTANT: never commit to main directly"]
