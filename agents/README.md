# Subagent Definitions

Subagent definition templates for `.claude/agents/*.md`. Subagents are
specialized agents that run with their own context and tool restrictions.

## How subagents work

- Custom subagents are defined as `.md` files in `.claude/agents/`
- They inherit the parent's CLAUDE.md + `.claude/rules/` by default
- Each subagent can restrict its tool access (e.g., read-only)
- Subagents are invoked by the parent agent when delegated a task

## Available templates

| File | Purpose |
|---|---|
| `reviewer.md` | Read-only code reviewer — reviews diffs, reports findings, no modifications |
| `planner.md` | Read-only planning agent — produces specs and plans, no code changes |

## Context inheritance note

Custom subagents inherit the parent's full CLAUDE.md and `.claude/rules/` context.
For large monorepos, this can bloat the subagent's context window. Keep rules
focused and minimal to avoid this. There is an open feature request for
per-subagent context exclusion (anthropics/claude-code#63855).
