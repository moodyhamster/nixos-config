#!/usr/bin/env bash

set -u

DESKTOP="${1:-}"

case "$DESKTOP" in
  kde|gnome)
    ;;
  *)
    echo "Usage: bash ~/nixos-config/switch-desktop.sh kde"
    echo "   or: bash ~/nixos-config/switch-desktop.sh gnome"
    exit 1
    ;;
esac

exec bash "$HOME/nixos-config/update-nixos-config.sh" "$DESKTOP"
