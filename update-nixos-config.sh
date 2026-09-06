#!/usr/bin/env bash

set -u

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

find_repo() {
  local candidate

  # Prefer the current user's checkout when it exists. If this is a newly
  # created account, fall back to the checkout owned by the other shared user.
  for candidate in \
    "$HOME/nixos-config" \
    /home/jason/nixos-config \
    /home/val/nixos-config
  do
    if [[ -d "$candidate/.git" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  return 1
}

echo "========================================"
echo "        NixOS Configuration Update"
echo "========================================"
echo

if ! REPO="$(find_repo)"; then
  echo "ERROR: No nixos-config Git checkout was found on this machine."
  echo "At least one account must clone moodyhamster/nixos-config first."
  pause
  exit 1
fi

REPO_OWNER="$(stat -c '%U' "$REPO")"

echo "1/3 Pulling latest configuration from GitHub..."
echo "Repository: $REPO"
echo "Repository owner: $REPO_OWNER"

# Pull as the owner of the checkout so a sudo-capable second account can use
# the existing owner's GitHub authentication instead of needing another clone.
if [[ "$(id -un)" == "$REPO_OWNER" ]]; then
  PULL_CMD=(git -C "$REPO" pull --ff-only)
else
  PULL_CMD=(sudo -H -u "$REPO_OWNER" git -C "$REPO" pull --ff-only)
fi

if ! "${PULL_CMD[@]}"; then
  echo
  echo "ERROR: git pull failed."
  pause
  exit 1
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
