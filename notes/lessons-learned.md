# Lessons learned

Running log of what's worked, what hasn't, and why. Update this whenever a CLAUDE.md
change actually moves the needle (good or bad) on a real project.

## 2026-06-20
- Shorter, rule-numbered CLAUDE.md files reportedly cut Claude's error rate sharply
  (41% no-file -> 11% basic rules -> 3% mature ~12-rule version), per community research.
  Takeaway: favor concrete numbered rules over long prose explanations.
- Claude reads CLAUDE.md sequentially — rules near the top get more consistent
  attention. Put highest-stakes constraints first, not buried at the bottom.
- Runnable-command instructions ("Run `npm test` before marking done") are followed
  more reliably than vague descriptions ("make sure tests pass") because Claude can
  actually execute and verify them.
- For complex/grown repos: keep the root CLAUDE.md under ~100 lines and push depth into
  path-scoped nested CLAUDE.md files (e.g. `apps/api/CLAUDE.md`) instead of growing the root file.

## 2026-06-22 — Research from last30days (3 searches, 127 items)

### Commands merged into skills
- As of Claude Code v2.1.3, `.claude/commands/*.md` and `.claude/skills/*/SKILL.md` both
  create slash commands. Skills are the recommended format — they support frontmatter,
  context injection, auto-invocation, and subdirectories. Commands kept for backward compat.
- Agent Skills follow an open standard that works across Claude Code, GitHub Copilot,
  Cursor, Windsurf, and others. A single SKILL.md can serve multiple tools.

### .cursorrules is legacy
- Cursor's Agent mode now ignores `.cursorrules` completely. It reads `.cursor/rules/*.mdc`
  files with YAML frontmatter (description, globs, alwaysApply). Four activation modes:
  Always Apply, Apply Intelligently, Apply to Specific Files (glob), Apply Manually.
- Keep rules under 50-60 lines each, one concern per file. Long rules get treated as
  documentation, not instructions.

### CLAUDE.md should be minimal and delegate
- Community consensus: keep CLAUDE.md for orchestration only (project purpose, build/test
  commands, architecture pointers). Don't put code style rules in it — use `.claude/rules/`
  or a linter. Delegate to skills and rules files.
- AGENTS.md gaining traction as the cross-tool base. uv's repo uses 17-line AGENTS.md
  with a one-liner CLAUDE.md referencing it. Pattern: write once in AGENTS.md, reference
  from tool-specific files.

### Read-before-write pattern
- The #1 workflow rule from the community: before modifying any files, the agent should
  restate the goal, list relevant files, identify top 3 risks, provide a step-by-step plan,
  and explain verification — all before modifying any files. No changes until human confirms.

### Spec/Plan/Ship pipeline
- The most popular skills package (64K+ stars) encodes /spec -> /plan -> /build -> /test ->
  /review -> /ship. We adopted this as our skill pipeline.

### Ponytail minimal-code ladder
- A ruleset that forces agents to write minimal viable code: YAGNI -> stdlib -> native
  platform -> installed deps -> one line -> minimum that works. More structured than
  our ask-before-adding rule.

### Session persistence via hooks
- SessionStart + PostToolUse hooks can save and restore working context across session
  timeouts. Pattern: CLAUDE.md gives the agent its bearings, hooks give it continuity.

### Subagent context inheritance
- Custom subagents inherit parent's CLAUDE.md + .claude/rules/ with no way to exclude.
  For large monorepos, this bloats context. Keep rules focused and minimal.
- Feature request open: anthropics/claude-code#63855

### DESIGN.md as agent-readable config
- 73+ DESIGN.md files from brands like Apple, Google, Stripe shared as agent-readable
  design system configs. New config type beyond CLAUDE.md/rules/skills.
