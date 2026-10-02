#!/bin/bash
# full_backup.sh - Full backup of a source directory using tar
# Author: Balakumar K T
# Usage: ./full_backup.sh [source] [destination]

set -euo pipefail

SOURCE=${1:-.}
DEST=${2:-./backups}
DATE=$(date +%Y%m%d_%H%M%S)
ARCHIVE="$DEST/full_backup_$DATE.tar.gz"

if [ ! -d "$SOURCE" ]; then
  echo "[ERROR] Source directory not found: $SOURCE"
  exit 1
fi

mkdir -p "$DEST"

echo "=========================================="
echo " Full Backup"
echo "=========================================="
echo " Source:      $SOURCE"
echo " Destination: $ARCHIVE"
echo " Started:     $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="

tar -czf "$ARCHIVE" "$SOURCE"

SIZE=$(du -h "$ARCHIVE" | cut -f1)
echo "[OK] Full backup complete"
echo "[OK] Size: $SIZE"
echo "[OK] File: $ARCHIVE"
echo "=========================================="