#!/usr/bin/env bash
set -Eeuo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Run with sudo: sudo $0" >&2
  exit 1
fi

for user in guest1 guest2; do
  if id "$user" >/dev/null 2>&1; then
    echo "$user already exists; not recreating."
  else
    useradd --create-home --shell /bin/bash "$user"
    echo "Created $user."
  fi
done

usermod -aG sudo guest1
echo
echo "guest1 group membership:"
id guest1

echo
echo "The assignment requires deleting guest2 INCLUDING its home directory."
read -r -p "Type DELETE guest2 to confirm: " confirmation
if [[ "$confirmation" == "DELETE guest2" ]]; then
  if id guest2 >/dev/null 2>&1; then
    userdel --remove guest2
    echo "guest2 and its home directory have been removed."
  else
    echo "guest2 does not exist; nothing to delete."
  fi
else
  echo "Deletion cancelled. guest2 remains on the system."
fi

echo
echo "Final account checks:"
id guest1
if getent passwd guest2 >/dev/null; then
  echo "guest2 still exists."
else
  echo "guest2 is absent."
fi
