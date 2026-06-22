---
name: review
description: "Review the current diff for correctness bugs, security issues, and reuse opportunities"
user-invocable: true
allowed-tools:
  - Read
  - Bash(git diff:*)
  - Bash(git log:*)
  - Grep
---

# Code Review

Review the current diff for correctness bugs first, then reuse/simplification opportunities.

1. Run `git diff` against the base branch to see the full changeset.
2. Check for: logic errors, missing edge cases, security issues (injection, secrets, unsafe input handling).
3. Check for: duplicated logic that already exists elsewhere in the repo, unnecessary abstraction, dead code.
4. Report findings as a short list, grouped by severity (bug vs. cleanup). Don't fix anything unless asked.
