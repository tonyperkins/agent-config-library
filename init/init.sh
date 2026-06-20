#!/usr/bin/env sh
set -eu

REPO_RAW="https://raw.githubusercontent.com/YOURNAME/agent-config-library/main"
TYPE=""
DEST="."

usage() {
  echo "Usage: curl -fsSL $REPO_RAW/init/init.sh | sh -s -- --type=<simple|api|web-frontend|monorepo> [--dest=.]"
  exit 1
}

for arg in "$@"; do
  case "$arg" in
    --type=*) TYPE="${arg#*=}" ;;
    --dest=*) DEST="${arg#*=}" ;;
    *) usage ;;
  esac
done

[ -z "$TYPE" ] && usage

MANIFEST_URL="$REPO_RAW/init/manifests/${TYPE}.manifest"
MANIFEST=$(curl -fsSL "$MANIFEST_URL") || { echo "Unknown type: $TYPE"; exit 1; }

echo "Initializing '$TYPE' agent config in $DEST ..."

echo "$MANIFEST" | while IFS= read -r line; do
  [ -z "$line" ] && continue
  case "$line" in \#*) continue ;; esac
  src=$(echo "$line" | awk '{print $1}')
  dst=$(echo "$line" | awk '{print $3}')
  mkdir -p "$DEST/$(dirname "$dst")"
  if [ -f "$DEST/$dst" ]; then
    echo "  skip (exists): $dst"
  else
    curl -fsSL "$REPO_RAW/$src" -o "$DEST/$dst"
    echo "  added: $dst"
  fi
done

echo "Done. Review the new files before committing."
