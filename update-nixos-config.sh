#!/usr/bin/env bash

set -u

REPO="/var/lib/nixos-config"
REPO_URL="https://github.com/moodyhamster/nixos-config.git"
MODE="update"

pause() {
  if [[ "${NIXOS_UPDATE_NO_PAUSE:-0}" == "1" ]]; then
    return
  fi

  echo
  read -r -p "Press Enter to close..." _ || true
}

usage() {
  echo "Usage: nixos-update [--local|--push]"
  echo
  echo "  nixos-update          Pull the latest configuration, then rebuild."
  echo "  nixos-update --local  Skip GitHub and rebuild from the existing local checkout."
  echo "  nixos-update --push   Push existing local commits to GitHub without rebuilding."
}

if [[ "$#" -gt 1 ]]; then
  usage
  exit 2
fi

case "${1:-}" in
  "")
    ;;
  --local|-l)
    MODE="local"
    ;;
  --push|-p)
    MODE="push"
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

# The checkout is root-owned at /var/lib/nixos-config. For pushes, make a
# temporary user-owned clone so GitHub authentication uses the normal user's
# credentials without changing ownership of the system checkout.
if [[ "$MODE" == "push" ]]; then
  echo "Pushing committed local configuration to GitHub..."
  echo "Repository: $REPO"

  if [[ ! -d "$REPO/.git" ]]; then
    echo
    echo "ERROR: No local configuration checkout exists at $REPO."
    echo "Run nixos-update once to create it."
    pause
    exit 1
  fi

  BRANCH="$(sudo git -C "$REPO" branch --show-current 2>/dev/null || true)"
  if [[ -z "$BRANCH" ]]; then
    echo
    echo "ERROR: Could not determine the current Git branch."
    pause
    exit 1
  fi

  if [[ -n "$(sudo git -C "$REPO" status --porcelain)" ]]; then
    echo
    echo "NOTE: The local checkout has uncommitted changes."
    echo "Only existing commits will be pushed; uncommitted files are not included."
  fi

  PUSH_TMP="$(mktemp -d)"
  cleanup_push_tmp() {
    rm -rf "$PUSH_TMP"
  }
  trap cleanup_push_tmp EXIT

  echo
  echo "Preparing a temporary copy for the push..."
  if ! sudo git clone --no-local --no-checkout "$REPO" "$PUSH_TMP/repo"; then
    echo
    echo "ERROR: Could not prepare the local repository for pushing."
    pause
    exit 1
  fi

  if ! sudo chown -R "$(id -u):$(id -g)" "$PUSH_TMP/repo"; then
    echo
    echo "ERROR: Could not prepare repository ownership for the push."
    pause
    exit 1
  fi

  if ! git -C "$PUSH_TMP/repo" remote set-url origin "$REPO_URL"; then
    echo
    echo "ERROR: Could not set the GitHub remote for the push."
    pause
    exit 1
  fi

  echo "Branch: $BRANCH"
  if git -C "$PUSH_TMP/repo" push origin "$BRANCH:$BRANCH"; then
    echo
    echo "========================================"
    echo " Configuration pushed successfully."
    echo " Branch: $BRANCH"
    echo "========================================"
    pause
    exit 0
  fi

  echo
  echo "ERROR: GitHub push failed."
  echo "Make sure your normal user is authenticated for GitHub pushes."
  echo "If needed, run 'gh auth login' and then 'gh auth setup-git'."
  echo "If GitHub has newer commits, run nixos-update first and resolve any conflicts."
  pause
  exit 1
fi

# The repository is public, so keep one root-owned checkout for the whole
# machine. Normal updates do not require a personal Git clone or GitHub login.
if [[ "$MODE" == "local" ]]; then
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
  if [[ "$MODE" == "local" ]]; then
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
