#!/usr/bin/env bash
set -Eeuo pipefail

LOG_FILE="${1:-$HOME/logs/sys_events.log}"
REPORT_FILE="${2:-$HOME/logs/error_report.txt}"

if [[ ! -f "$LOG_FILE" ]]; then
  echo "Log file not found: $LOG_FILE" >&2
  echo "Create it first with scripts/02_create_logs.sh." >&2
  exit 1
fi

echo "=== Lines containing ERROR ==="
grep "ERROR" "$LOG_FILE" || true

echo
echo "=== Lines mentioning root or user01 ==="
grep -E "root|user01" "$LOG_FILE" || true

echo
echo "=== ERROR results through less (interactive) ==="
if command -v less >/dev/null 2>&1; then
  grep "ERROR" "$LOG_FILE" | less
else
  echo "less is not installed; pager demonstration skipped."
fi

grep "ERROR" "$LOG_FILE" > "$REPORT_FILE"
echo
echo "=== Saved error report: $REPORT_FILE ==="
cat "$REPORT_FILE"

echo
echo "=== First 5 lines ==="
head -n 5 "$LOG_FILE"

echo
echo "=== Last 5 lines ==="
tail -n 5 "$LOG_FILE"

echo
echo "=== Full log ==="
cat "$LOG_FILE"
