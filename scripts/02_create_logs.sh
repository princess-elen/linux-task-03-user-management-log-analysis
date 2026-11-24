#!/usr/bin/env bash
set -Eeuo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "Run this as forensic01, not as root. Use: su - forensic01" >&2
  exit 1
fi
if [[ "$(id -un)" != "forensic01" ]]; then
  echo "Warning: current user is $(id -un), expected forensic01." >&2
  read -r -p "Continue anyway? [y/N] " answer
  [[ "$answer" =~ ^[Yy]$ ]] || exit 1
fi

LOG_DIR="$HOME/logs"
mkdir -p "$LOG_DIR"

cat > "$LOG_DIR/sys_events.log" <<'LOGS'
2026-11-24 08:00:01 INFO system boot completed
2026-11-24 08:02:14 INFO user01 logged in from console
2026-11-24 08:05:33 WARNING disk usage reached 75 percent
2026-11-24 08:07:10 ERROR failed authentication for user01
2026-11-24 08:09:42 INFO root started scheduled maintenance
2026-11-24 08:12:08 WARNING unusual process activity detected
2026-11-24 08:15:19 ERROR service database failed to start
2026-11-24 08:18:27 INFO user01 opened system dashboard
2026-11-24 08:21:44 INFO root updated package index
2026-11-24 08:24:03 WARNING memory usage reached 80 percent
2026-11-24 08:27:16 ERROR permission denied while accessing archive
2026-11-24 08:30:29 INFO backup process started by root
2026-11-24 08:33:51 INFO user01 saved a configuration file
2026-11-24 08:36:07 WARNING network latency above threshold
2026-11-24 08:39:22 ERROR failed to write application log
2026-11-24 08:42:35 INFO root checked filesystem integrity
2026-11-24 08:45:48 INFO user01 logged out
2026-11-24 08:48:02 WARNING repeated login attempts observed
2026-11-24 08:51:13 ERROR authentication service timeout
2026-11-24 08:54:26 INFO system monitoring completed
LOGS

chmod 0640 "$LOG_DIR/sys_events.log"
echo "Created $LOG_DIR/sys_events.log"
wc -l "$LOG_DIR/sys_events.log"
ls -l "$LOG_DIR/sys_events.log"
