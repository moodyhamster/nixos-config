#!/usr/bin/env bash

set -u

REPO="$HOME/nixos-config"

pause() {
  echo
  read -r -p "Press Enter to close..." _ || true
}

echo "========================================"
echo "        NixOS Configuration Update"
echo "========================================"
echo

if [[ ! -d "$REPO/.git" ]]; then
  echo "ERROR: $REPO is not a Git repository."
  echo "Clone moodyhamster/nixos-config there first."
  pause
  exit 1
fi

cd "$REPO" || exit 1

echo "1/3 Pulling latest configuration from GitHub..."
if ! git pull --ff-only; then
  echo
  echo "ERROR: git pull failed."
  pause
  exit 1
fi

HOST="$(hostnamectl --static 2>/dev/null || hostname)"
CONFIG="$REPO/hosts/$HOST/configuration.nix"

echo
echo "2/3 Selecting configuration for host: $HOST"
if [[ ! -f "$CONFIG" ]]; then
  echo
  echo "ERROR: No configuration exists for this machine."
  echo "Expected: $CONFIG"
  echo
  echo "To add this computer, create hosts/$HOST/configuration.nix"
  echo "from hosts/_template/configuration.nix and set its bootloader options."
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
  echo "========================================"
  pause
  exit 0
fi

echo
 echo "Rebuild failed. The running NixOS generation was not replaced."
echo "Fix the configuration in GitHub or roll back the change, then try again."
pause
exit 1
