## Code style (TypeScript)
- `strict: true` in tsconfig — no implicit any, no untyped catches
- No default exports; named exports only
- Prefer `type` over `interface` unless declaration merging is needed
- No `any` — use `unknown` and narrow, or fix the actual type
- Functions over classes unless there's clear shared mutable state to encapsulate
