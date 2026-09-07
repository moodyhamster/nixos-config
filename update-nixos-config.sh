#!/usr/bin/env bash

set -u

REPO="/var/lib/nixos-config"
REPO_URL="https://github.com/moodyhamster/nixos-config.git"

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
# machine. Normal updates do not require a personal Git clone or GitHub login.
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
CONFIG="$REPO/hosts/$HOST/kde.nix"

echo
echo "2/3 Selecting KDE configuration for host: $HOST"
if [[ ! -f "$CONFIG" ]]; then
  echo
  echo "ERROR: No KDE configuration exists for this machine."
  echo "Expected: $CONFIG"
  pause
  exit 1
fi

echo "Using: $CONFIG"

echo
echo "3/3 Rebuilding NixOS..."
if sudo nixos-rebuild switch -I "nixos-config=$CONFIG"; then
  echo
  echo "========================================"
  echo " NixOS updated successfully."
  echo " Host: $HOST"
  echo " Desktop: KDE Plasma"
  echo "========================================"
  pause
  exit 0
fi

echo
echo "Rebuild failed. The running NixOS generation was not replaced."
echo "Fix the configuration in GitHub or roll back the change, then try again."
pause
exit 1
