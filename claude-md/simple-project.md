# Project: [name]

## What this is
[1-2 sentences: purpose, not implementation. Claude can't infer business intent from code.]
[Name the actual shape: e.g. "single-user local tool", "public demo", "multi-tenant SaaS". The right amount of engineering depends on which one this is.]

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
- Read `AGENTS.md` first for cross-tool project context
- See `.claude/rules/` for code style, workflow, and dependency rules
- [Branch naming, commit message format, PR requirements if any]

## IMPORTANT
- IMPORTANT: Build the smallest thing that satisfies the requirement. Don't add abstractions, services, or dependencies for anticipated future needs — solve the problem as stated and flag anything you think is coming so the human decides.
- IMPORTANT: Read the actual source/config before claiming how something works or what needs to change — verify, don't assume.
- [Reserve remaining IMPORTANT slots for 1-2 truly project-critical rules, e.g. "IMPORTANT: never commit to main directly"]
