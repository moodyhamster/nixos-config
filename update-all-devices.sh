#!/usr/bin/env bash

set -u

REPO="$HOME/nixos-config"
REMOTE_HOSTS=(
  "thinkpad-c13.local"
  "rog-strix-g16.local"
)

pause() {
  echo
  read -r -p "Press Enter to close..." _ || true
}

CURRENT_HOST="$(hostnamectl --static 2>/dev/null || hostname)"
FAILURES=0

echo "========================================"
echo "          Update All NixOS Devices"
echo "========================================"
echo

echo "Updating this machine: $CURRENT_HOST"
if NIXOS_UPDATE_NO_PAUSE=1 bash "$REPO/update-nixos-config.sh"; then
  echo "Local update completed."
else
  echo "Local update failed."
  FAILURES=$((FAILURES + 1))
fi

for remote in "${REMOTE_HOSTS[@]}"; do
  short_name="${remote%.local}"

  if [[ "$short_name" == "$CURRENT_HOST" ]]; then
    continue
  fi

  echo
  echo "----------------------------------------"
  echo "Updating remote machine: $short_name"
  echo "----------------------------------------"

  if ssh \
    -o ConnectTimeout=8 \
    -o StrictHostKeyChecking=accept-new \
    -t "jason@$remote" \
    'NIXOS_UPDATE_NO_PAUSE=1 bash ~/nixos-config/update-nixos-config.sh'; then
    echo "$short_name updated successfully."
  else
    echo "$short_name could not be updated. It may be offline or SSH may need attention."
    FAILURES=$((FAILURES + 1))
  fi
done

echo
if [[ "$FAILURES" -eq 0 ]]; then
  echo "========================================"
  echo " All reachable NixOS devices updated."
  echo "========================================"
else
  echo "========================================"
  echo " Finished with $FAILURES failed update(s)."
  echo "========================================"
fi

pause
exit "$FAILURES"
