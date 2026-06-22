#!/usr/bin/env sh
# Simple test for init.sh — runs against the local working copy (no network).
# Usage: sh init/test-init.sh
set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_RAW="file://$REPO_ROOT"
INIT_SH="$SCRIPT_DIR/init.sh"

PASS=0
FAIL=0

ok() {
  echo "  PASS: $1"
  PASS=$((PASS + 1))
}

fail() {
  echo "  FAIL: $1"
  FAIL=$((FAIL + 1))
}

assert_exists() {
  if [ -f "$1" ]; then
    ok "file exists: $2"
  else
    fail "file missing: $2 ($1)"
  fi
}

assert_contains() {
  if grep -qF "$2" "$1" 2>/dev/null; then
    ok "content check: $3"
  else
    fail "content check failed: $3 (expected '$2' in $1)"
  fi
}

echo "=== Test 1: dry-run --type=simple ==="
TMPDIR1=$(mktemp -d)
OUTPUT1=$(REPO_RAW="$REPO_RAW" sh "$INIT_SH" --type=simple --dest="$TMPDIR1" --dry-run 2>&1) || true

echo "$OUTPUT1" | grep -qF "would add: CLAUDE.md" && ok "dry-run shows CLAUDE.md" || fail "dry-run output missing CLAUDE.md"
echo "$OUTPUT1" | grep -qF "would add: .claude/rules/git.md" && ok "dry-run shows git.md" || fail "dry-run output missing git.md"
echo "$OUTPUT1" | grep -qF "would add: AGENTS.md" && ok "dry-run shows AGENTS.md" || fail "dry-run output missing AGENTS.md"
echo "$OUTPUT1" | grep -qF "would add: .claude/settings.json" && ok "dry-run shows settings.json" || fail "dry-run output missing settings.json"

# Dry-run should not create any files
if [ -f "$TMPDIR1/CLAUDE.md" ]; then
  fail "dry-run wrote CLAUDE.md (should not have)"
else
  ok "dry-run did not write files"
fi

rm -rf "$TMPDIR1"

echo ""
echo "=== Test 2: real run --type=simple ==="
TMPDIR2=$(mktemp -d)
REPO_RAW="$REPO_RAW" sh "$INIT_SH" --type=simple --dest="$TMPDIR2" 2>&1

assert_exists "$TMPDIR2/CLAUDE.md" "CLAUDE.md"
assert_exists "$TMPDIR2/AGENTS.md" "AGENTS.md"
assert_exists "$TMPDIR2/.claude/rules/code-style.md" ".claude/rules/code-style.md"
assert_exists "$TMPDIR2/.claude/rules/meta.md" ".claude/rules/meta.md"
assert_exists "$TMPDIR2/.claude/rules/workflow.md" ".claude/rules/workflow.md"
assert_exists "$TMPDIR2/.claude/rules/read-before-write.md" ".claude/rules/read-before-write.md"
assert_exists "$TMPDIR2/.claude/rules/zero-placeholders.md" ".claude/rules/zero-placeholders.md"
assert_exists "$TMPDIR2/.claude/rules/defensive-commits.md" ".claude/rules/defensive-commits.md"
assert_exists "$TMPDIR2/.claude/rules/interface-first.md" ".claude/rules/interface-first.md"
assert_exists "$TMPDIR2/.claude/rules/dependencies.md" ".claude/rules/dependencies.md"
assert_exists "$TMPDIR2/.claude/rules/verify-imports.md" ".claude/rules/verify-imports.md"
assert_exists "$TMPDIR2/.claude/rules/agent-boundaries.md" ".claude/rules/agent-boundaries.md"
assert_exists "$TMPDIR2/.claude/rules/git.md" ".claude/rules/git.md"
assert_exists "$TMPDIR2/.claude/settings.json" ".claude/settings.json"

# Cross-tool sync
assert_exists "$TMPDIR2/GEMINI.md" "GEMINI.md"
assert_exists "$TMPDIR2/.windsurfrules" ".windsurfrules"
assert_exists "$TMPDIR2/.github/copilot-instructions.md" ".github/copilot-instructions.md"
assert_exists "$TMPDIR2/.cursor/rules/project.mdc" ".cursor/rules/project.mdc"

assert_contains "$TMPDIR2/CLAUDE.md" "# Project:" "CLAUDE.md has expected header"
assert_contains "$TMPDIR2/.claude/rules/git.md" "Conventional Commits" "git.md has expected content"
assert_contains "$TMPDIR2/.claude/rules/workflow.md" "One logical change" "workflow.md has expected content"
assert_contains "$TMPDIR2/.claude/rules/read-before-write.md" "restate the goal" "read-before-write rule has expected content"
assert_contains "$TMPDIR2/.claude/rules/zero-placeholders.md" "placeholder" "zero-placeholders rule has expected content"
assert_contains "$TMPDIR2/GEMINI.md" "Conventional Commits" "GEMINI.md has synced rules"
assert_contains "$TMPDIR2/.cursor/rules/project.mdc" "alwaysApply: true" "Cursor .mdc has frontmatter"
assert_contains "$TMPDIR2/.github/copilot-instructions.md" "Conventional Commits" "Copilot instructions has synced rules"

rm -rf "$TMPDIR2"

echo ""
echo "=== Test 3: real run --type=monorepo (comments in manifest) ==="
TMPDIR3=$(mktemp -d)
REPO_RAW="$REPO_RAW" sh "$INIT_SH" --type=monorepo --dest="$TMPDIR3" 2>&1

assert_exists "$TMPDIR3/CLAUDE.md" "CLAUDE.md"
assert_exists "$TMPDIR3/AGENTS.md" "AGENTS.md"
assert_exists "$TMPDIR3/.mcp.json" ".mcp.json"
assert_exists "$TMPDIR3/.claude/rules/testing.md" ".claude/rules/testing.md"
assert_exists "$TMPDIR3/.claude/rules/security.md" ".claude/rules/security.md"
assert_exists "$TMPDIR3/.claude/rules/agent-boundaries.md" ".claude/rules/agent-boundaries.md"
assert_exists "$TMPDIR3/.claude/rules/workflow.md" ".claude/rules/workflow.md"
assert_exists "$TMPDIR3/.claude/rules/read-before-write.md" ".claude/rules/read-before-write.md"
assert_exists "$TMPDIR3/.claude/rules/zero-placeholders.md" ".claude/rules/zero-placeholders.md"
assert_exists "$TMPDIR3/.claude/rules/defensive-commits.md" ".claude/rules/defensive-commits.md"
assert_exists "$TMPDIR3/.claude/rules/interface-first.md" ".claude/rules/interface-first.md"
assert_exists "$TMPDIR3/.claude/rules/dependencies.md" ".claude/rules/dependencies.md"
assert_exists "$TMPDIR3/.claude/rules/verify-imports.md" ".claude/rules/verify-imports.md"
# Cross-tool sync
assert_exists "$TMPDIR3/GEMINI.md" "GEMINI.md"
assert_exists "$TMPDIR3/.windsurfrules" ".windsurfrules"
assert_exists "$TMPDIR3/.github/copilot-instructions.md" ".github/copilot-instructions.md"
assert_exists "$TMPDIR3/.cursor/rules/project.mdc" ".cursor/rules/project.mdc"

# The monorepo manifest has trailing comment lines — ensure they didn't create bogus files
if [ -d "$TMPDIR3/Reminder:" ]; then
  fail "comment line was parsed as a file path"
else
  ok "comment lines in manifest were correctly skipped"
fi

rm -rf "$TMPDIR3"

echo ""
echo "=== Test 4: idempotent re-run (files identical) ==="
TMPDIR4=$(mktemp -d)
REPO_RAW="$REPO_RAW" sh "$INIT_SH" --type=simple --dest="$TMPDIR4" >/dev/null 2>&1
OUTPUT4=$(REPO_RAW="$REPO_RAW" sh "$INIT_SH" --type=simple --dest="$TMPDIR4" 2>&1)

echo "$OUTPUT4" | grep -qF "skip (up to date): CLAUDE.md" && ok "re-run skips identical CLAUDE.md" || fail "re-run did not skip identical CLAUDE.md"

rm -rf "$TMPDIR4"

echo ""
echo "=== Test 5: --force overwrites modified files ==="
TMPDIR5=$(mktemp -d)
REPO_RAW="$REPO_RAW" sh "$INIT_SH" --type=simple --dest="$TMPDIR5" >/dev/null 2>&1
echo "modified" > "$TMPDIR5/CLAUDE.md"
OUTPUT5=$(REPO_RAW="$REPO_RAW" sh "$INIT_SH" --type=simple --dest="$TMPDIR5" --force 2>&1)

echo "$OUTPUT5" | grep -qF "replaced: CLAUDE.md" && ok "--force replaced modified CLAUDE.md" || fail "--force did not replace modified CLAUDE.md"
if [ -d "$TMPDIR5/.claude-init-backup" ]; then
  ok "backup was created"
else
  fail "backup directory was not created"
fi

rm -rf "$TMPDIR5"

echo ""
echo "=== Test 6: missing --type shows usage ==="
OUTPUT6=$(REPO_RAW="$REPO_RAW" sh "$INIT_SH" 2>&1 || true)
echo "$OUTPUT6" | grep -qF "Usage:" && ok "missing --type shows usage" || fail "missing --type did not show usage"

echo ""
echo "=== Test 7: unknown --type fails gracefully ==="
OUTPUT7=$(REPO_RAW="$REPO_RAW" sh "$INIT_SH" --type=nonexistent 2>&1 || true)
echo "$OUTPUT7" | grep -qF "Unknown type" && ok "unknown type shows error" || fail "unknown type did not show error"

echo ""
echo "=== Test 8: python manifest ==="
TMPDIR8=$(mktemp -d)
REPO_RAW="$REPO_RAW" sh "$INIT_SH" --type=python --dest="$TMPDIR8" 2>&1

assert_exists "$TMPDIR8/CLAUDE.md" "CLAUDE.md"
assert_exists "$TMPDIR8/AGENTS.md" "AGENTS.md"
assert_exists "$TMPDIR8/.claude/rules/code-style.md" ".claude/rules/code-style.md"
assert_contains "$TMPDIR8/.claude/rules/code-style.md" "PEP 8" "python code-style applied"
assert_exists "$TMPDIR8/.claude/rules/testing.md" ".claude/rules/testing.md"
assert_exists "$TMPDIR8/.claude/rules/read-before-write.md" ".claude/rules/read-before-write.md"
assert_exists "$TMPDIR8/.claude/rules/zero-placeholders.md" ".claude/rules/zero-placeholders.md"
assert_exists "$TMPDIR8/GEMINI.md" "GEMINI.md"
assert_exists "$TMPDIR8/.cursor/rules/project.mdc" ".cursor/rules/project.mdc"

rm -rf "$TMPDIR8"

echo ""
echo "=== Test 9: web-frontend includes deploy-checklist ==="
TMPDIR9=$(mktemp -d)
REPO_RAW="$REPO_RAW" sh "$INIT_SH" --type=web-frontend --dest="$TMPDIR9" 2>&1

assert_exists "$TMPDIR9/AGENTS.md" "AGENTS.md"
assert_exists "$TMPDIR9/.claude/rules/code-style.md" "code-style.md"
assert_exists "$TMPDIR9/.claude/rules/read-before-write.md" "read-before-write.md"
assert_contains "$TMPDIR9/.claude/rules/code-style.md" "TypeScript" "typescript code-style applied"
assert_exists "$TMPDIR9/GEMINI.md" "GEMINI.md"
assert_contains "$TMPDIR9/GEMINI.md" "TypeScript" "GEMINI.md has synced TypeScript rules"

rm -rf "$TMPDIR9"

echo ""
echo "=== Test 10: simple manifest includes code-style ==="
TMPDIR10=$(mktemp -d)
REPO_RAW="$REPO_RAW" sh "$INIT_SH" --type=simple --dest="$TMPDIR10" 2>&1

assert_exists "$TMPDIR10/AGENTS.md" "AGENTS.md"
assert_exists "$TMPDIR10/.claude/rules/code-style.md" "code-style.md"
assert_exists "$TMPDIR10/.claude/rules/agent-boundaries.md" "agent-boundaries.md"
assert_exists "$TMPDIR10/GEMINI.md" "GEMINI.md"
assert_exists "$TMPDIR10/.windsurfrules" ".windsurfrules"

rm -rf "$TMPDIR10"

echo ""
echo "=== Test 11: design manifest includes DESIGN.md and subagents ==="
TMPDIR11=$(mktemp -d)
REPO_RAW="$REPO_RAW" sh "$INIT_SH" --type=design --dest="$TMPDIR11" 2>&1

assert_exists "$TMPDIR11/CLAUDE.md" "CLAUDE.md"
assert_exists "$TMPDIR11/AGENTS.md" "AGENTS.md"
assert_exists "$TMPDIR11/DESIGN.md" "DESIGN.md"
assert_exists "$TMPDIR11/.claude/agents/reviewer.md" "reviewer subagent"
assert_exists "$TMPDIR11/.claude/agents/planner.md" "planner subagent"
assert_exists "$TMPDIR11/.claude/rules/agent-boundaries.md" "agent-boundaries.md"
assert_exists "$TMPDIR11/GEMINI.md" "GEMINI.md"
assert_exists "$TMPDIR11/.cursor/rules/project.mdc" ".cursor/rules/project.mdc"

rm -rf "$TMPDIR11"

echo ""
echo "=== Test 12: fullstack manifest includes everything ==="
TMPDIR12=$(mktemp -d)
REPO_RAW="$REPO_RAW" sh "$INIT_SH" --type=fullstack --dest="$TMPDIR12" 2>&1

assert_exists "$TMPDIR12/CLAUDE.md" "CLAUDE.md"
assert_exists "$TMPDIR12/AGENTS.md" "AGENTS.md"
assert_exists "$TMPDIR12/DESIGN.md" "DESIGN.md"
assert_exists "$TMPDIR12/.mcp.json" ".mcp.json"
assert_exists "$TMPDIR12/.claude/agents/reviewer.md" "reviewer subagent"
assert_exists "$TMPDIR12/.claude/agents/planner.md" "planner subagent"
assert_exists "$TMPDIR12/.claude/rules/testing.md" "testing.md"
assert_exists "$TMPDIR12/.claude/rules/security.md" "security.md"
assert_exists "$TMPDIR12/GEMINI.md" "GEMINI.md"
assert_exists "$TMPDIR12/.github/copilot-instructions.md" "copilot-instructions.md"
assert_contains "$TMPDIR12/GEMINI.md" "failing test" "GEMINI.md has synced testing rules"

rm -rf "$TMPDIR12"

echo ""
echo "==========================="
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" = 0 ] && exit 0 || exit 1
