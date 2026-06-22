# Code Reviewer Skill

## Description
Reviews a diff or set of files for correctness bugs, security issues, and cleanup opportunities.

## When to use
Invoke this skill when the user asks for a code review, wants to check a diff before
committing, or says something like "review this" or "look over my changes."

## Instructions

1. Determine the scope: if there's a current `git diff`, use that. Otherwise, ask the
   user which files or changes to review.
2. Check for **correctness** first:
   - Logic errors, off-by-one, null/undefined access
   - Missing edge cases (empty input, concurrent access, error paths)
   - Incorrect type usage or assumptions
3. Check for **security**:
   - Injection vulnerabilities (SQL, command, path traversal)
   - Secrets or credentials in the diff
   - Unsafe deserialization or eval
4. Check for **cleanup**:
   - Duplicated logic that already exists elsewhere
   - Unnecessary abstraction for the current complexity level
   - Dead code, unused imports, commented-out blocks
5. Report findings as a short list grouped by severity:
   - **Bugs** — things that will break
   - **Security** — things that could be exploited
   - **Cleanup** — things that make the code harder to maintain
6. Do not fix anything unless explicitly asked. Just report.

## Output format
```
## Review: [scope description]

### Bugs
- [file:line] description

### Security
- [file:line] description

### Cleanup
- [file:line] description
```

If a category has no findings, omit it entirely.
