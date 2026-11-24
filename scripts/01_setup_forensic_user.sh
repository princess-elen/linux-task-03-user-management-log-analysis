#!/usr/bin/env bash
set -Eeuo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Run with sudo: sudo $0" >&2
  exit 1
fi

USERNAME="forensic01"
HOME_DIR="/home/${USERNAME}"
SHELL_PATH="/bin/bash"

if ! getent group sudo >/dev/null; then
  echo "This script expects a 'sudo' group (Ubuntu/Debian-style)." >&2
  exit 1
fi

if id "$USERNAME" >/dev/null 2>&1; then
  echo "User $USERNAME already exists; leaving account and password unchanged."
  if [[ "$(getent passwd "$USERNAME" | cut -d: -f6)" != "$HOME_DIR" ]]; then
    echo "WARNING: existing home directory differs from $HOME_DIR."
  fi
else
  useradd --create-home --home-dir "$HOME_DIR" --shell "$SHELL_PATH" "$USERNAME"
  echo "Created $USERNAME."
  passwd "$USERNAME"
fi

usermod -aG sudo "$USERNAME"
install -d -o "$USERNAME" -g "$USERNAME" -m 0750 "$HOME_DIR/logs"

echo
echo "Verification:"
id "$USERNAME"
getent passwd "$USERNAME"
ls -ld "$HOME_DIR" "$HOME_DIR/logs"
echo "If the account already existed, set/reset its password separately with: sudo passwd $USERNAME"
