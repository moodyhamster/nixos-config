#!/usr/bin/env bash

set -u

REPO="${HOME}/nixos-config"
LEGACY_REPO="/var/lib/nixos-config"
REPO_URL="https://github.com/moodyhamster/nixos-config.git"

pause() {
  if [[ "${NIXOS_UPDATE_NO_PAUSE:-0}" == "1" ]]; then
    return
  fi

  echo
  read -r -p "Press Enter to close..." _ || true
}

if [[ "$EUID" -eq 0 ]]; then
  echo "ERROR: Run nixos-update as your normal user, without sudo."
  exit 1
fi

echo "========================================"
echo "        NixOS Configuration Update"
echo "========================================"
echo

# Keep the working checkout in the user's home directory. Existing machines
# that still use the old root-owned /var/lib checkout are migrated once.
if [[ ! -e "$REPO" && -d "$LEGACY_REPO/.git" ]]; then
  echo "Migrating configuration checkout to: $REPO"
  if ! sudo mv "$LEGACY_REPO" "$REPO"; then
    echo
    echo "ERROR: Could not move the old configuration checkout."
    pause
    exit 1
  fi

  if ! sudo chown -R "$(id -u):$(id -g)" "$REPO"; then
    echo
    echo "ERROR: Could not give the current user ownership of $REPO."
    pause
    exit 1
  fi
fi

if [[ -d "$REPO/.git" ]]; then
  echo "1/3 Pulling latest configuration from GitHub..."
  echo "Repository: $REPO"
  if ! git -C "$REPO" pull --ff-only; then
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

  echo "1/3 Creating the NixOS configuration checkout..."
  echo "Repository: $REPO"
  if ! git clone "$REPO_URL" "$REPO"; then
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
  echo " Repository: $REPO"
  echo "========================================"
  pause
  exit 0
fi

echo
echo "Rebuild failed. The running NixOS generation was not replaced."
echo "Fix the configuration in GitHub or roll back the change, then try again."
pause
exit 1
