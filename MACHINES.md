# Machine plan

Each physical computer has a unique host directory with a shared machine base plus separate KDE and GNOME system configurations.

KDE Plasma is the default desktop on every host. GNOME is available as a separate build. The selected desktop is stored locally in `/etc/nixos/desktop-environment`, so normal updates preserve the last successful choice.

The single managed user is `kim`, with `networkmanager` and `wheel` membership. Passwords are set locally and are never stored in Git.

OpenSSH is enabled for local-network remote access on every managed host through `modules/common.nix`.

Identical physical machines use unique numbered hostnames such as `thinkpad-c13-2` and `thinkpad-c13-3`. They may reuse the same model profile, but each machine keeps its own generated `/etc/nixos/hardware-configuration.nix`.

## Host layout

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
- `configuration.nix` is the KDE-default compatibility entry point for that host.

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

## Dell OptiPlex desktop 2

- Managed hostname: `dell-optiplex-2`
- User: `kim`
- Default desktop: KDE Plasma 6
- Alternate desktop: GNOME
- Bootloader: GRUB on `/dev/nvme0n1`
- `system.stateVersion`: `26.05`
- Gaming profile: enabled
- Model profile: `profiles/hardware/dell-optiplex.nix`
- Host directory: `hosts/dell-optiplex-2/`
- Uses this machine's own generated `/etc/nixos/hardware-configuration.nix`

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
- NVIDIA open kernel module and PRIME render offload are configured in the model profile

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

## Switching desktops

```bash
nixos-switch-desktop gnome
```

```bash
nixos-switch-desktop kde
```

The active build contains only the chosen desktop profile. Home-directory settings are preserved when switching.

## Adding an identical machine

Copy the existing host directory for that model, assign a unique hostname, and verify the new machine's original `system.stateVersion`. Reuse the same `profiles/hardware/<model>.nix` when the model/specs match.

Do not copy another machine's `/etc/nixos/hardware-configuration.nix`; disk UUIDs and detected filesystem settings can differ even between identical machines.

## Information to collect from a new model

```bash
hostnamectl --static

grep -R 'system.stateVersion' /etc/nixos/configuration.nix

if [ -d /sys/firmware/efi ]; then echo UEFI; else echo BIOS; fi

lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS

lspci -nnk | grep -A3 -E 'VGA|3D|Display'
```

For a brand-new model, begin with `hosts/_template/`. Once its hardware setup is known-good, move reusable bootloader, graphics and other model-specific settings into `profiles/hardware/<model>.nix`.
