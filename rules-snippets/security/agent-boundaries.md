## Security
- Never commit code without user review - always present changes for approval first
- Never delete config files (`.env`, `package.json`, `tsconfig.json`, etc.) without explicit confirmation
- If you find a security vulnerability, STOP and report it immediately - do not attempt to fix it without guidance
- Never run destructive commands (`rm -rf`, `DROP TABLE`, `git push --force`) without explicit user approval
- If a task requires access to secrets or credentials, ask the user to provide them - never search for or extract them yourself
