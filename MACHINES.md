# Machine plan

Each physical computer has a unique host directory with a shared machine base plus separate KDE and GNOME system configurations.

**KDE Plasma is currently the default desktop on every host.** GNOME is also available on every host as a separate build. A machine's selected desktop is stored locally in `/etc/nixos/desktop-environment`, so normal updates preserve the last successful choice.

Every managed host declares one normal user named `kim`. The account is a member of `networkmanager`, `wheel` and `shared`, so it can manage networking, use `sudo`, and use `/srv/shared`. Passwords are set locally and are never stored in Git.

Identical physical machines use unique numbered hostnames such as `thinkpad-c13-2` and `thinkpad-c13-3`. They may reuse the same model profile, but each machine keeps its own generated `/etc/nixos/hardware-configuration.nix`.

## Host layout

Each real host uses this pattern:

```text
hosts/<hostname>/
├── base.nix
├── kde.nix
├── gnome.nix
└── configuration.nix
```

- `base.nix` contains machine identity, common settings, model profile and original `system.stateVersion`.
- `kde.nix` imports `base.nix` plus `profiles/kde.nix`.
- `gnome.nix` imports `base.nix` plus `profiles/gnome.nix`.
- `configuration.nix` is a compatibility/default entry point and currently imports `kde.nix`.

## Dell OptiPlex desktop

- Managed hostname: `dell-optiplex`
- User: `kim`
- Default desktop: KDE Plasma 6
- Alternate desktop: GNOME
- Bootloader: GRUB on `/dev/nvme0n1`
- `system.stateVersion`: `26.05`
- Gaming profile: enabled
- Model profile: `profiles/hardware/dell-optiplex.nix`
- Host directory: `hosts/dell-optiplex/`

## Lenovo ThinkPad C13 Yoga Chromebook Gen 1

- Managed hostname: `thinkpad-c13`
- User: `kim`
- Default desktop: KDE Plasma 6
- Alternate desktop: GNOME
- CPU/GPU: AMD Ryzen 5 3500C with integrated Radeon Vega graphics
- Boot mode: UEFI
- Bootloader: systemd-boot
- Storage: NVMe, FAT32 EFI partition mounted at `/boot`, ext4 root filesystem
- `system.stateVersion`: `26.05`
- Model profile: `profiles/hardware/thinkpad-c13.nix`
- Host directory: `hosts/thinkpad-c13/`
- OpenSSH is enabled for local-network remote access.

## ASUS ROG Strix G16 (2023)

- Managed hostname: `rog-strix-g16`
- User: `kim`
- Model: `ROG Strix G614JV_G614JV`
- Default desktop: KDE Plasma 6
- Alternate desktop: GNOME
- CPU: Intel Core i7-13650HX
- Integrated GPU: Intel Raptor Lake-S UHD Graphics, PCI `0000:00:02.0`
- Dedicated GPU: NVIDIA GeForce RTX 4060 Laptop GPU (AD107M), PCI `0000:01:00.0`
- Boot mode: UEFI
- Bootloader: systemd-boot
- Storage: 1 TB NVMe, 1 GB FAT32 EFI partition mounted at `/boot`, ext4 root filesystem
- `system.stateVersion`: `26.05`
- Gaming profile: enabled
- Model profile: `profiles/hardware/rog-strix-g16.nix`
- Host directory: `hosts/rog-strix-g16/`
- NVIDIA open kernel module and PRIME render offload are configured in the model profile.
- OpenSSH is enabled for local-network remote access.

## Dell Inspiron 3501

- Managed hostname: `dell-inspiron-3501`
- User: `kim`
- Default desktop: KDE Plasma 6
- Alternate desktop: GNOME
- CPU: Intel Core i7-1165G7
- GPU: Intel Iris Xe Graphics (Tiger Lake-LP GT2), PCI `0000:00:02.0`
- Boot mode: UEFI
- Bootloader: systemd-boot
- Storage: 512 GB NVMe, 1 GB FAT32 EFI partition mounted at `/boot`, ext4 root filesystem
- `system.stateVersion`: `26.05`
- Model profile: `profiles/hardware/dell-inspiron-3501.nix`
- Host directory: `hosts/dell-inspiron-3501/`
- OpenSSH is enabled for local-network remote access.

## Switching desktops

Switch a host to GNOME:

```bash
nixos-switch-desktop gnome
```

Switch it to KDE:

```bash
nixos-switch-desktop kde
```

The active NixOS build contains only the chosen desktop profile. User home-directory settings are not erased when switching.

## Migrating older users

The managed configuration now declares only `kim`, while `users.mutableUsers = true` remains enabled. Existing older local users are therefore not automatically deleted during rebuild. After `kim` has a password, needed files have been copied to `/home/kim`, and login has been verified, old local accounts can be removed manually.

## Adding an identical machine

Copy the existing host directory for that model, assign a unique hostname, and verify the new machine's original `system.stateVersion`. Reuse the same `profiles/hardware/<model>.nix` when the model/specs match.

Do not copy another machine's `/etc/nixos/hardware-configuration.nix`; disk UUIDs and detected filesystem settings can differ even between identical models.

## Information to collect from a new model

```bash
hostnamectl --static

grep -R 'system.stateVersion' /etc/nixos/configuration.nix

if [ -d /sys/firmware/efi ]; then echo UEFI; else echo BIOS; fi

lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS

lspci -nnk | grep -A3 -E 'VGA|3D|Display'
```

For a brand-new model, begin with `hosts/_template/`. Once its hardware setup is known-good, move reusable bootloader, graphics and SSH settings into `profiles/hardware/<model>.nix`.
