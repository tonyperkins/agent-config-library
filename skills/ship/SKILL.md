---
name: ship
description: "Final verification before merge: run full test suite, check linting, verify no secrets, confirm changelog, create PR"
user-invocable: true
allowed-tools:
  - Read
  - Bash
  - Grep
---

# Ship

Final verification before merging or deploying. Run every check - don't skip any.

1. **Tests** - Run the full test suite (not just the tests for your changes). Everything must pass.
2. **Lint/typecheck** - Run the project's lint and type checking commands. Zero errors.
3. **Secrets scan** - Search the diff for API keys, tokens, passwords, and connection strings. Use `git diff --staged` and grep for common secret patterns.
4. **Debug cleanup** - Check for leftover `console.log`, `print()`, `debugger`, or debug-only code in the diff.
5. **Changelog** - If the repo has a CHANGELOG.md, verify this change is documented. If it tracks versions, verify the version bump is correct.
6. **Migration safety** - If the change includes DB migrations, confirm they are backward compatible or have a documented rollback.
7. **Report** - Output a pass/fail checklist for all 6 items. If any fail, stop and report - do not proceed to PR creation.
8. **PR** - If all checks pass, create the PR with a description that references the spec and plan.

Do not deploy directly. Create a PR for review. The only exception is if the user explicitly asks you to deploy.
