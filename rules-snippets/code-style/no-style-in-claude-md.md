## Meta
- Do not put code style rules in CLAUDE.md - use `.claude/rules/` snippets or a linter instead
- CLAUDE.md is for orchestration: project purpose, build/test commands, architecture pointers, and delegation to rules/skills
- The agent already knows common style conventions - don't restate what a linter already enforces
- If you find yourself adding style rules to CLAUDE.md, stop and create a `.claude/rules/` file instead
- Keep CLAUDE.md under 50 lines - if it's longer, something belongs in a rule snippet or skill
