<!--
Place this at e.g. apps/api/CLAUDE.md — it loads only when Claude is working
in that directory, instead of bloating the root CLAUDE.md.
-->

# [Subsystem name] conventions

## Stack specifics
- [ORM, validation library, auth pattern used here specifically]

## Commands (scoped)
- Test this service: `cd apps/api && npm test`
- Migration: `npm run db:migrate`

## Patterns
- [Concrete: "All endpoints return {data, error} shape", "Use the existing `withAuth` middleware, don't reinvent"]

## Gotchas
- [Things that bit you before — this is where tribal knowledge belongs]

<!--
If Claude seems to ignore a rule in here, check whether this file has actually
been loaded yet — run /memory to confirm what's in context.
-->
