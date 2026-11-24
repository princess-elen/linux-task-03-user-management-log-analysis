#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT_DIR/evidence/verification"
mkdir -p "$OUT"

{
  echo "Linux Task 03 verification"
  date -Is
  echo
  echo "=== forensic01 account ==="
  if id forensic01 2>&1; then getent passwd forensic01; else echo "forensic01 not found"; fi
  echo
  echo "=== guest1 account ==="
  if id guest1 2>&1; then getent passwd guest1; else echo "guest1 not found"; fi
  echo
  echo "=== guest2 account check ==="
  if getent passwd guest2; then echo "guest2 exists"; else echo "guest2 absent"; fi
} > "$OUT/user-verification.txt"

{
  echo "Linux Task 03 file verification"
  date -Is
  for f in /home/forensic01/logs/sys_events.log /home/forensic01/logs/error_report.txt /home/forensic01/logs/confidential.txt; do
    echo
    echo "--- $f ---"
    if [[ -e "$f" ]]; then
      ls -l "$f"
      stat -c 'owner=%U group=%G mode=%a size=%s' "$f"
    else
      echo "Not found"
    fi
  done
  if [[ -f /home/forensic01/logs/sys_events.log ]]; then
    echo
    echo "Log line count:"
    wc -l /home/forensic01/logs/sys_events.log
  fi
} > "$OUT/file-verification.txt" 2>&1

echo "Evidence text saved under $OUT"
echo "Capture real screenshots separately; see screenshots/README.md."
