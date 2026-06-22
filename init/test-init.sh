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
echo "$OUTPUT1" | grep -qF "would add: .claude/commands/review.md" && ok "dry-run shows review.md" || fail "dry-run output missing review.md"
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
assert_exists "$TMPDIR2/.claude/rules/git.md" ".claude/rules/git.md"
assert_exists "$TMPDIR2/.claude/commands/review.md" ".claude/commands/review.md"
assert_exists "$TMPDIR2/.claude/settings.json" ".claude/settings.json"

assert_contains "$TMPDIR2/CLAUDE.md" "# Project:" "CLAUDE.md has expected header"
assert_contains "$TMPDIR2/.claude/rules/git.md" "Conventional Commits" "git.md has expected content"

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
assert_exists "$TMPDIR3/.claude/commands/deploy-checklist.md" ".claude/commands/deploy-checklist.md"

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
assert_exists "$TMPDIR8/.claude/rules/code-style.md" ".claude/rules/code-style.md"
assert_contains "$TMPDIR8/.claude/rules/code-style.md" "PEP 8" "python code-style applied"
assert_exists "$TMPDIR8/.claude/rules/testing.md" ".claude/rules/testing.md"
assert_exists "$TMPDIR8/.claude/commands/review.md" ".claude/commands/review.md"

rm -rf "$TMPDIR8"

echo ""
echo "=== Test 9: web-frontend includes deploy-checklist ==="
TMPDIR9=$(mktemp -d)
REPO_RAW="$REPO_RAW" sh "$INIT_SH" --type=web-frontend --dest="$TMPDIR9" 2>&1

assert_exists "$TMPDIR9/.claude/commands/deploy-checklist.md" "deploy-checklist.md"
assert_exists "$TMPDIR9/.claude/rules/code-style.md" "code-style.md"
assert_contains "$TMPDIR9/.claude/rules/code-style.md" "TypeScript" "typescript code-style applied"

rm -rf "$TMPDIR9"

echo ""
echo "=== Test 10: simple manifest includes code-style ==="
TMPDIR10=$(mktemp -d)
REPO_RAW="$REPO_RAW" sh "$INIT_SH" --type=simple --dest="$TMPDIR10" 2>&1

assert_exists "$TMPDIR10/.claude/rules/code-style.md" "code-style.md"

rm -rf "$TMPDIR10"

echo ""
echo "==========================="
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" = 0 ] && exit 0 || exit 1
