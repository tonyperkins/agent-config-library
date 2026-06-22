---
name: deploy-checklist
description: "Verify a change is ready to deploy: tests, lint, secrets, migrations, changelog"
user-invocable: true
allowed-tools:
  - Read
  - Bash
  - Grep
---

# Deploy Checklist

Before confirming this change is ready to deploy, verify:

1. All tests pass - run the test command, don't assume.
2. Lint/typecheck is clean.
3. No secrets or debug logging left in the diff.
4. Migration/schema changes (if any) are backward compatible or have a documented rollback.
5. CHANGELOG or release notes updated if this repo tracks them.

Report a pass/fail checklist. Do not deploy - just confirm readiness.
