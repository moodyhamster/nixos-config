#!/usr/bin/env bash

set -u

echo "========================================"
echo "           Sync System Clock"
echo "========================================"
echo

echo "Enabling network time synchronization..."
if ! sudo timedatectl set-ntp true; then
  echo
  echo "ERROR: Could not enable network time synchronization."
  echo
  read -r -p "Press Enter to close..." _ || true
  exit 1
fi

echo "Restarting systemd-timesyncd..."
if ! sudo systemctl restart systemd-timesyncd.service; then
  echo
  echo "ERROR: Could not restart systemd-timesyncd."
  echo
  read -r -p "Press Enter to close..." _ || true
  exit 1
fi

sleep 3

echo
echo "Current time:"
date

echo
echo "Time synchronization status:"
timedatectl status

echo
timedatectl timesync-status 2>/dev/null || true

echo
read -r -p "Press Enter to close..." _ || true
