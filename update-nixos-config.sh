#!/usr/bin/env bash

set -u

REPO="/var/lib/nixos-config"
REPO_URL="https://github.com/moodyhamster/nixos-config.git"
LOCAL_ONLY=0

pause() {
  if [[ "${NIXOS_UPDATE_NO_PAUSE:-0}" == "1" ]]; then
    return
  fi

  echo
  read -r -p "Press Enter to close..." _ || true
}

usage() {
  echo "Usage: nixos-update [--local]"
  echo
  echo "  nixos-update          Pull the latest configuration, then rebuild."
  echo "  nixos-update --local  Skip GitHub and rebuild from the existing local checkout."
}

if [[ "$#" -gt 1 ]]; then
  usage
  exit 2
fi

case "${1:-}" in
  "")
    ;;
  --local|-l)
    LOCAL_ONLY=1
    ;;
  --help|-h)
    usage
    exit 0
    ;;
  *)
    echo "ERROR: Unknown option: $1"
    echo
    usage
    exit 2
    ;;
esac

echo "========================================"
echo "        NixOS Configuration Update"
echo "========================================"
echo

# The repository is public, so keep one root-owned checkout for the whole
# machine. Normal updates do not require a personal Git clone or GitHub login.
if [[ "$LOCAL_ONLY" -eq 1 ]]; then
  echo "1/3 Using existing local configuration..."
  echo "Repository: $REPO"
  echo "GitHub pull: skipped"

  if [[ ! -d "$REPO/.git" ]]; then
    echo
    echo "ERROR: No local configuration checkout exists at $REPO."
    echo "Run nixos-update without --local once to create it."
    pause
    exit 1
  fi
else
  if [[ -d "$REPO/.git" ]]; then
    echo "1/3 Pulling latest configuration from GitHub..."
    echo "Repository: $REPO"
    if ! sudo git -C "$REPO" pull --ff-only; then
      echo
      echo "ERROR: git pull failed."
      echo "You can use 'nixos-update --local' to rebuild from the existing checkout."
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
  if [[ "$LOCAL_ONLY" -eq 1 ]]; then
    echo " Source: local configuration"
  else
    echo " Source: latest GitHub configuration"
  fi
  echo "========================================"
  pause
  exit 0
fi

echo
echo "Rebuild failed. The running NixOS generation was not replaced."
echo "Fix the configuration in GitHub or roll back the change, then try again."
pause
exit 1
