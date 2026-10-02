#!/bin/bash
# restore.sh - Restore files from a tar.gz backup archive
# Author: Balakumar K T
# Usage: ./restore.sh <archive.tar.gz> <destination_dir>

set -euo pipefail

ARCHIVE=${1:?Usage: restore.sh <archive.tar.gz> <destination_dir>}
DEST=${2:?Usage: restore.sh <archive.tar.gz> <destination_dir>}

if [ ! -f "$ARCHIVE" ]; then
  echo "[ERROR] Archive not found: $ARCHIVE"
  exit 1
fi

echo "=========================================="
echo " Restore Operation"
echo "=========================================="
echo " Archive:     $ARCHIVE"
echo " Destination: $DEST"
echo " Started:     $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="

mkdir -p "$DEST"
tar -xzf "$ARCHIVE" -C "$DEST"

echo "[OK] Restore complete"
echo "[OK] Files restored to: $DEST"
echo "=========================================="