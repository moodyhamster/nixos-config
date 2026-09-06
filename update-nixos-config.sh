#!/usr/bin/env bash

set -u

REPO="/var/lib/nixos-config"
REPO_URL="https://github.com/moodyhamster/nixos-config.git"
DESKTOP_FILE="/etc/nixos/desktop-environment"
REQUESTED_DESKTOP="${1:-}"
SAVE_SELECTION=0

pause() {
  if [[ "${NIXOS_UPDATE_NO_PAUSE:-0}" == "1" ]]; then
    return
  fi

  echo
  read -r -p "Press Enter to close..." _ || true
}

echo "========================================"
echo "        NixOS Configuration Update"
echo "========================================"
echo

# The repository is public, so keep one root-owned checkout for the whole
# machine. Either sudo-capable user can update without a personal Git clone or
# GitHub authentication.
if [[ -d "$REPO/.git" ]]; then
  echo "1/3 Pulling latest configuration from GitHub..."
  echo "Repository: $REPO"
  if ! sudo git -C "$REPO" pull --ff-only; then
    echo
    echo "ERROR: git pull failed."
    pause
    exit 1
  fi
else
  if [[ -e "$REPO" ]]; then
    echo "ERROR: $REPO exists but is not a Git repository."
    echo "Move or remove that path, then run nixos-update again."
    pause
    exit 1
  fi

  echo "1/3 Creating the shared NixOS configuration checkout..."
  echo "Repository: $REPO"
  if ! sudo git clone "$REPO_URL" "$REPO"; then
    echo
    echo "ERROR: git clone failed."
    pause
    exit 1
  fi
fi

HOST="$(hostnamectl --static 2>/dev/null || hostname)"

if [[ -n "$REQUESTED_DESKTOP" ]]; then
  DESKTOP="$REQUESTED_DESKTOP"
  SAVE_SELECTION=1
elif [[ -r "$DESKTOP_FILE" ]]; then
  DESKTOP="$(tr -d '[:space:]' < "$DESKTOP_FILE")"
else
  # Repository-wide default for machines that have never selected a desktop.
  DESKTOP="kde"
fi

case "$DESKTOP" in
  kde|gnome)
    ;;
  *)
    echo
    echo "ERROR: Invalid desktop selection: $DESKTOP"
    echo "Expected kde or gnome."
    pause
    exit 1
    ;;
esac

CONFIG="$REPO/hosts/$HOST/$DESKTOP.nix"

echo
echo "2/3 Selecting configuration for host: $HOST"
echo "Desktop: $DESKTOP"
if [[ ! -f "$CONFIG" ]]; then
  echo
  echo "ERROR: No $DESKTOP configuration exists for this machine."
  echo "Expected: $CONFIG"
  pause
  exit 1
fi

echo "Using: $CONFIG"

echo
echo "3/3 Rebuilding NixOS..."
if sudo nixos-rebuild switch -I "nixos-config=$CONFIG"; then
  if [[ "$SAVE_SELECTION" == "1" ]]; then
    printf '%s\n' "$DESKTOP" | sudo tee "$DESKTOP_FILE" >/dev/null
  fi

  echo
  echo "========================================"
  echo " NixOS updated successfully."
  echo " Host: $HOST"
  echo " Desktop: $DESKTOP"
  echo "========================================"
  pause
  exit 0
fi

echo
echo "Rebuild failed. The running NixOS generation was not replaced."
echo "The saved desktop selection was not changed."
echo "Fix the configuration in GitHub or roll back the change, then try again."
pause
exit 1
