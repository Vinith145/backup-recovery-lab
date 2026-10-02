#!/bin/bash
# backup_verify.sh - Verify integrity of a tar.gz backup archive
# Author: Balakumar K T
# Usage: ./backup_verify.sh <archive.tar.gz>

set -euo pipefail

ARCHIVE=${1:?Usage: backup_verify.sh <archive.tar.gz>}

if [ ! -f "$ARCHIVE" ]; then
  echo "[ERROR] Archive not found: $ARCHIVE"
  exit 1
fi

echo "=========================================="
echo " Backup Verification"
echo "=========================================="
echo " Archive: $ARCHIVE"
echo "=========================================="

if tar -tzf "$ARCHIVE" >/dev/null 2>&1; then
  COUNT=$(tar -tzf "$ARCHIVE" | wc -l)
  SIZE=$(du -h "$ARCHIVE" | cut -f1)
  echo "[OK]   Archive is valid"
  echo "[INFO] Size: $SIZE"
  echo "[INFO] Entries: $COUNT"
  echo ""
  echo "First 10 entries:"
  tar -tzf "$ARCHIVE" | head -n 10
  exit 0
else
  echo "[FAIL] Archive is corrupted or unreadable"
  exit 1
fi