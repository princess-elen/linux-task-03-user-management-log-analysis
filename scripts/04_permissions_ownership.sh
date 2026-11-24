#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "$(id -un)" != "forensic01" ]]; then
  echo "Run this script while logged in as forensic01." >&2
  exit 1
fi

FILE="$HOME/logs/confidential.txt"
mkdir -p "$HOME/logs"
touch "$FILE"
chmod 600 "$FILE"

echo "=== Before ownership change ==="
ls -l "$FILE"
stat -c 'owner=%U group=%G mode=%a path=%n' "$FILE"

echo
echo "Changing ownership to root:root (sudo password may be requested)..."
sudo chown root:root "$FILE"

echo
echo "=== After ownership change ==="
ls -l "$FILE"
stat -c 'owner=%U group=%G mode=%a path=%n' "$FILE"

echo
echo "=== Read test as $(id -un) (failure is expected with mode 600) ==="
if cat "$FILE"; then
  echo "Read succeeded in this environment; record this actual result."
else
  echo "Read failed, as expected for a non-owner without permission."
fi

echo
echo "=== Write test as $(id -un) (failure is expected with mode 600) ==="
if echo "test entry" >> "$FILE"; then
  echo "Write succeeded in this environment; record this actual result."
else
  echo "Write failed, as expected for a non-owner without permission."
fi

echo
echo "Administrator inspection:"
sudo ls -l "$FILE"
sudo cat "$FILE"
