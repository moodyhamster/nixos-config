# Machine plan

This repository uses shared modules plus role profiles. Each real computer gets its own `hosts/<hostname>/configuration.nix`.

User accounts are host-specific so machines can keep their existing login names while still sharing the same system applications and settings.

## Current desktop

- Managed hostname: `nixos`
- Login user: `jason`
- Desktop environment: KDE Plasma 6
- Role profiles: `desktop-kde.nix` + `gaming.nix`
- Current host entry: `hosts/nixos/configuration.nix`

## Lenovo ThinkPad C13 Yoga Chromebook Gen 1

- Managed hostname: `thinkpad-c13`
- Login user: `jason`
- Desktop environment: GNOME
- CPU/GPU: AMD Ryzen 5 3500C with integrated Radeon Vega graphics
- Boot mode: UEFI
- Bootloader: systemd-boot
- Storage: NVMe, FAT32 EFI partition mounted at `/boot`, ext4 root filesystem
- `system.stateVersion`: `26.05`
- Role profile: `laptop-gnome.nix`
- Host entry: `hosts/thinkpad-c13/configuration.nix`
- OpenSSH is enabled for remote access from the local network.
- AMD integrated graphics use the normal in-kernel `amdgpu` stack; no proprietary GPU configuration is needed.

## ASUS ROG Strix G16 (2023)

- Managed hostname: `rog-strix-g16`
- Login user: `jason`
- Model: `ROG Strix G614JV_G614JV`
- Desktop environment: GNOME
- CPU: Intel Core i7-13650HX
- Integrated GPU: Intel Raptor Lake-S UHD Graphics, PCI `0000:00:02.0`
- Dedicated GPU: NVIDIA GeForce RTX 4060 Laptop GPU (AD107M), PCI `0000:01:00.0`
- Boot mode: UEFI
- Bootloader: systemd-boot
- Storage: 1 TB NVMe, 1 GB FAT32 EFI partition mounted at `/boot`, ext4 root filesystem
- `system.stateVersion`: `26.05`
- Role profiles: `laptop-gnome.nix` + `gaming.nix`
- Host entry: `hosts/rog-strix-g16/configuration.nix`
- NVIDIA's current driver stack is enabled with the open kernel module and PRIME render offload.
- GNOME normally runs on the Intel iGPU; `nvidia-offload <command>` can launch an application on the RTX 4060.
- OpenSSH is enabled for remote access from the local network.

## Dell Inspiron 3501

- Managed hostname: `dell-inspiron-3501`
- Login user: `val`
- Desktop environment: GNOME
- CPU: Intel Core i7-1165G7
- GPU: Intel Iris Xe Graphics (Tiger Lake-LP GT2), PCI `0000:00:02.0`
- Boot mode: UEFI
- Bootloader: systemd-boot
- Storage: 512 GB NVMe, 1 GB FAT32 EFI partition mounted at `/boot`, ext4 root filesystem
- `system.stateVersion`: `26.05`
- Role profile: `laptop-gnome.nix`
- Host entry: `hosts/dell-inspiron-3501/configuration.nix`
- Intel graphics use the normal in-kernel driver stack; no proprietary GPU configuration is needed.
- OpenSSH is enabled for remote access from the local network.

## Information to collect from future machines

Useful commands when creating a new host entry:

```bash
hostnamectl --static

grep -R 'system.stateVersion' /etc/nixos/configuration.nix

if [ -d /sys/firmware/efi ]; then echo UEFI; else echo BIOS; fi

lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS

lspci -nnk | grep -A3 -E 'VGA|3D|Display'
```

Keep `/etc/nixos/hardware-configuration.nix` local to each computer. It contains machine-specific filesystems, UUIDs and detected hardware settings.
