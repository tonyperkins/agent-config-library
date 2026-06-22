#!/usr/bin/env sh
set -eu

REPO_RAW="${REPO_RAW:-https://raw.githubusercontent.com/tonyperkins/agent-config-library/main}"
TYPE=""
DEST="."
FORCE=0
NO_BACKUP=0
DRY_RUN=0

usage() {
  cat <<USAGE
Usage:
  curl -fsSL https://raw.githubusercontent.com/tonyperkins/agent-config-library/main/init/init.sh \\
    | sh -s -- --type=<simple|api|web-frontend|python|monorepo|design|fullstack> [options]

Options:
  --type=TYPE      Required. Which manifest to use (see manifests/).
  --dest=PATH      Destination directory (default: current directory).
  --force          Overwrite all conflicting files without prompting.
  --no-backup      Skip creating backups when replacing files (combine with --force).
  --dry-run        Show what would happen without writing or backing up anything.
  -h, --help       Show this help.

Default behavior:
  - New files are added.
  - Existing files identical to the repo version are skipped silently.
  - Existing files that differ are: prompted interactively (if a terminal is
    available), or skipped with a warning (if not) — unless --force is set.
  - Any file that gets replaced is backed up first to
    DEST/.claude-init-backup/<timestamp>/ unless --no-backup is set.
USAGE
  exit 1
}

for arg in "$@"; do
  case "$arg" in
    --type=*) TYPE="${arg#*=}" ;;
    --dest=*) DEST="${arg#*=}" ;;
    --force) FORCE=1 ;;
    --no-backup) NO_BACKUP=1 ;;
    --dry-run) DRY_RUN=1 ;;
    -h|--help) usage ;;
    *) echo "Unknown argument: $arg"; usage ;;
  esac
done

[ -z "$TYPE" ] && usage

MANIFEST_URL="$REPO_RAW/init/manifests/${TYPE}.manifest"
MANIFEST=$(curl -fsSL "$MANIFEST_URL") || { echo "Unknown type: $TYPE"; exit 1; }

# Heuristic for "can we actually prompt": stdout being a terminal is a decent
# proxy even when this script itself arrived via a piped curl, since the
# pipe only occupies stdin, not stdout. We read answers from /dev/tty
# directly so the exhausted stdin pipe never gets in the way.
INTERACTIVE=0
if [ -t 1 ] && [ -r /dev/tty ] 2>/dev/null; then
  INTERACTIVE=1
fi

TIMESTAMP=$(date -u +%Y%m%dT%H%M%SZ)
BACKUP_ROOT="$DEST/.claude-init-backup/$TIMESTAMP"
BACKED_UP=0

echo "Initializing '$TYPE' agent config in $DEST ..."
[ "$DRY_RUN" = 1 ] && echo "(dry run — no files will be written)"

backup_then_replace() {
  # $1 = tmpfile (new content), $2 = dst (relative to DEST)
  tmpfile="$1"
  dst="$2"
  if [ "$NO_BACKUP" != 1 ] && [ "$DRY_RUN" != 1 ]; then
    mkdir -p "$BACKUP_ROOT/$(dirname "$dst")"
    cp "$DEST/$dst" "$BACKUP_ROOT/$dst"
    BACKED_UP=1
  fi
  if [ "$DRY_RUN" = 1 ]; then
    echo "  would replace: $dst"
    rm -f "$tmpfile"
  else
    mv "$tmpfile" "$DEST/$dst"
    echo "  replaced: $dst"
  fi
}

while IFS= read -r line; do
  [ -z "$line" ] && continue
  case "$line" in \#*) continue ;; esac
  line="${line%% \#*}"
  [ -z "$line" ] && continue
  src="${line%% -> *}"
  dst="${line##* -> }"
  src="${src#"${src%%[![:space:]]*}"}"
  src="${src%"${src##*[![:space:]]}"}"
  dst="${dst#"${dst%%[![:space:]]*}"}"
  dst="${dst%"${dst##*[![:space:]]}"}"
  [ -z "$src" ] || [ -z "$dst" ] || [ "$src" = "$dst" ] && continue

  mkdir -p "$DEST/$(dirname "$dst")"
  tmpfile=$(mktemp)
  if ! curl -fsSL "$REPO_RAW/$src" -o "$tmpfile"; then
    echo "  fetch failed, skipping: $dst"
    rm -f "$tmpfile"
    continue
  fi

  if [ ! -f "$DEST/$dst" ]; then
    if [ "$DRY_RUN" = 1 ]; then
      echo "  would add: $dst"
      rm -f "$tmpfile"
    else
      mv "$tmpfile" "$DEST/$dst"
      echo "  added: $dst"
    fi
    continue
  fi

  if cmp -s "$tmpfile" "$DEST/$dst"; then
    echo "  skip (up to date): $dst"
    rm -f "$tmpfile"
    continue
  fi

  # File exists and differs from the repo version.
  if [ "$FORCE" = 1 ]; then
    backup_then_replace "$tmpfile" "$dst"
    continue
  fi

  if [ "$INTERACTIVE" != 1 ]; then
    echo "  skip (modified, non-interactive): $dst — rerun with --force to overwrite"
    rm -f "$tmpfile"
    continue
  fi

  while true; do
    printf '  %s differs from the repo version. [s]kip (default) / [r]eplace / [d]iff: ' "$dst" > /dev/tty
    read -r answer < /dev/tty || answer="s"
    case "$answer" in
      d|D)
        diff -u "$DEST/$dst" "$tmpfile" | sed -n '1,80p' > /dev/tty || true
        continue
        ;;
      r|R)
        backup_then_replace "$tmpfile" "$dst"
        break
        ;;
      *)
        echo "  skip: $dst"
        rm -f "$tmpfile"
        break
        ;;
    esac
  done
done <<MANIFEST_EOF
$MANIFEST
MANIFEST_EOF

# ── Cross-tool sync ──────────────────────────────────────────────────────────
# After deploying AGENTS.md and .claude/rules/*.md via the manifest, sync the
# combined rules content to each tool's expected location so that Gemini,
# Windsurf, Copilot, and Cursor all see the same rules as Claude Code.
# This runs after the manifest loop, only on real (non-dry-run) executions.

sync_cross_tool() {
  if [ "$DRY_RUN" = 1 ]; then
    echo "  (dry run — skipping cross-tool sync)"
    return 0
  fi

  # Build combined content: AGENTS.md + all .claude/rules/*.md
  combined=""
  if [ -f "$DEST/AGENTS.md" ]; then
    combined=$(cat "$DEST/AGENTS.md")
  fi
  if [ -d "$DEST/.claude/rules" ]; then
    rules_content=""
    for rulefile in "$DEST"/.claude/rules/*.md; do
      [ -f "$rulefile" ] || continue
      rules_content="$rules_content

---

$(cat "$rulefile")"
    done
    if [ -n "$rules_content" ]; then
      combined="$combined

## Rules

$rules_content"
    fi
  fi

  if [ -z "$combined" ]; then
    return 0
  fi

  # Gemini: GEMINI.md
  mkdir -p "$DEST"
  if [ ! -f "$DEST/GEMINI.md" ] || [ "$FORCE" = 1 ]; then
    printf '%s\n' "$combined" > "$DEST/GEMINI.md"
    echo "  synced: GEMINI.md"
  fi

  # Windsurf: .windsurfrules
  if [ ! -f "$DEST/.windsurfrules" ] || [ "$FORCE" = 1 ]; then
    printf '%s\n' "$combined" > "$DEST/.windsurfrules"
    echo "  synced: .windsurfrules"
  fi

  # GitHub Copilot: .github/copilot-instructions.md
  mkdir -p "$DEST/.github"
  if [ ! -f "$DEST/.github/copilot-instructions.md" ] || [ "$FORCE" = 1 ]; then
    printf '%s\n' "$combined" > "$DEST/.github/copilot-instructions.md"
    echo "  synced: .github/copilot-instructions.md"
  fi

  # Cursor: .cursor/rules/project.mdc (with YAML frontmatter)
  mkdir -p "$DEST/.cursor/rules"
  cursor_file="$DEST/.cursor/rules/project.mdc"
  if [ ! -f "$cursor_file" ] || [ "$FORCE" = 1 ]; then
    cursor_frontmatter="---
description: Project rules synced from AGENTS.md
globs:
alwaysApply: true
---"
    printf '%s\n%s\n' "$cursor_frontmatter" "$combined" > "$cursor_file"
    echo "  synced: .cursor/rules/project.mdc"
  fi
}

sync_cross_tool

if [ "$BACKED_UP" = 1 ]; then
  echo "Backups saved to: $BACKUP_ROOT"
fi
echo "Done. Review the new files before committing."
