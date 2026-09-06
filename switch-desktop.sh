#!/usr/bin/env bash

set -u

DESKTOP="${1:-}"

case "$DESKTOP" in
  kde|gnome)
    ;;
  *)
    echo "Usage: nixos-switch-desktop kde"
    echo "   or: nixos-switch-desktop gnome"
    exit 1
    ;;
esac

# Prefer the system-wide command so this works for either shared user. Keep a
# repository-local fallback for machines that have not rebuilt this change yet.
if command -v nixos-update >/dev/null 2>&1; then
  exec nixos-update "$DESKTOP"
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
exec bash "$SCRIPT_DIR/update-nixos-config.sh" "$DESKTOP"
