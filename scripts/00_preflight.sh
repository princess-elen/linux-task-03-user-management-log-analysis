#!/usr/bin/env bash
set -Eeuo pipefail

echo "=== Linux Task 03 preflight ==="
if [[ -r /etc/os-release ]]; then
  . /etc/os-release
  echo "OS: ${PRETTY_NAME:-unknown}"
else
  echo "OS: unable to identify"
fi

for cmd in sudo useradd usermod userdel passwd chown chmod grep head tail cat id getent; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '[OK] %s\n' "$cmd"
  else
    printf '[MISSING] %s\n' "$cmd"
  fi
done

echo
echo "Current user: $(id -un)"
if sudo -n true 2>/dev/null; then
  echo "Sudo: available without password prompt"
elif sudo -v; then
  echo "Sudo: available"
else
  echo "Sudo: unavailable; ask your lab administrator."
fi

for user in forensic01 guest1 guest2; do
  if getent passwd "$user" >/dev/null; then
    echo "[EXISTS] $user"
  else
    echo "[AVAILABLE] $user"
  fi
done

echo
echo "Preflight complete. Review existing accounts before running setup scripts."
