## Workflow
- Before starting any multi-file refactoring, create a git checkpoint: `git add -A && git commit -m "checkpoint: before <task>"`
- After every successful test run, commit immediately - don't accumulate uncommitted changes
- Never modify more than 3 files without an intermediate commit
- If a refactoring goes sideways, you can always `git reset` back to the last checkpoint
- Commit messages for checkpoints: `checkpoint: <what you just completed>`
