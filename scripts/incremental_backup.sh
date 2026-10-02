#!/bin/bash
# incremental_backup.sh - Incremental backup using tar + hardlinks
# Author: Balakumar K T
# Usage: ./incremental_backup.sh [source] [destination]

set -euo pipefail

SOURCE=${1:-.}
DEST=${2:-./backups/incremental}
DATE=$(date +%Y%m%d_%H%M%S)
SNAPSHOT="$DEST/snapshot_$DATE"
LATEST="$DEST/latest"
LATEST_MARKER="$DEST/latest.txt"

if [ ! -d "$SOURCE" ]; then
  echo "[ERROR] Source directory not found: $SOURCE"
  exit 1
fi

# Ensure destination directories exist first
mkdir -p "$DEST"
mkdir -p "$SNAPSHOT"

echo "=========================================="
echo " Incremental Backup"
echo "=========================================="
echo " Source:  $SOURCE"
echo " Target:  $SNAPSHOT"
echo "=========================================="

# Detect previous snapshot - check symlink OR marker file
PREV=""
if [ -e "$LATEST" ]; then
  PREV=$(readlink -f "$LATEST" 2>/dev/null || echo "$LATEST")
elif [ -f "$LATEST_MARKER" ]; then
  PREV=$(cat "$LATEST_MARKER")
fi

if [ -n "$PREV" ] && [ -d "$PREV" ]; then
  echo "[INFO] Previous snapshot found: $PREV"
  echo "[INFO] Using hardlink-based incremental copy"

  # Copy previous snapshot using hardlinks (fallback to normal copy)
  cp -al "$PREV/." "$SNAPSHOT/" 2>/dev/null || \
    cp -a "$PREV/." "$SNAPSHOT/"

  echo "[INFO] Copying changed/new files..."
  find "$SOURCE" -type f | while read -r file; do
    rel="${file#$SOURCE/}"
    mkdir -p "$SNAPSHOT/$(dirname "$rel")"
    cp -f "$file" "$SNAPSHOT/$rel"
  done
else
  echo "[INFO] No previous snapshot found - creating first full copy"
  cp -a "$SOURCE/." "$SNAPSHOT/"
fi

# Update 'latest' pointer - try symlink first, fallback to marker file
if ln -sfn "$SNAPSHOT" "$LATEST" 2>/dev/null; then
  echo "[OK] 'latest' symlink updated"
else
  echo "$SNAPSHOT" > "$LATEST_MARKER"
  echo "[OK] 'latest' pointer written to $LATEST_MARKER (symlink unavailable)"
fi

echo "[OK] Incremental backup complete"
echo "[OK] Snapshot: $SNAPSHOT"
echo "=========================================="