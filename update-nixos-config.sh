#!/usr/bin/env bash

set -u

REPO="$HOME/nixos-config"
SOURCE="$REPO/configuration.nix"
TARGET="/etc/nixos/configuration.nix"
BACKUP="/etc/nixos/configuration.nix.backup"

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
  echo "Clone the repo first, then run this again."
  pause
  exit 1
fi

cd "$REPO" || exit 1

echo "1/4 Pulling latest configuration from GitHub..."
if ! git pull --ff-only; then
  echo
  echo "ERROR: git pull failed. Nothing was changed in /etc/nixos."
  pause
  exit 1
fi

if [[ ! -f "$SOURCE" ]]; then
  echo
  echo "ERROR: $SOURCE does not exist."
  pause
  exit 1
fi

echo
echo "2/4 Backing up current configuration..."
if [[ -f "$TARGET" ]]; then
  sudo cp -a "$TARGET" "$BACKUP" || {
    echo "ERROR: Could not create backup."
    pause
    exit 1
  }
fi

echo
echo "3/4 Installing the GitHub-managed configuration..."
sudo cp "$SOURCE" "$TARGET" || {
  echo "ERROR: Could not copy configuration.nix."
  pause
  exit 1
}

echo
echo "4/4 Rebuilding NixOS..."
if sudo nixos-rebuild switch; then
  echo
  echo "========================================"
  echo " NixOS updated successfully."
  echo "========================================"
  pause
  exit 0
fi

echo
 echo "Rebuild failed. Restoring the previous configuration file..."
if [[ -f "$BACKUP" ]]; then
  sudo cp "$BACKUP" "$TARGET"
  echo "Previous configuration.nix restored."
else
  echo "No backup file was available to restore."
fi

echo
echo "The running NixOS generation was not replaced by the failed rebuild."
pause
exit 1
