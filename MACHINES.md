# Machine plan

This repository uses shared modules plus role profiles. Each real computer gets its own `hosts/<hostname>/configuration.nix`.

## Current desktop

- Desktop environment: KDE Plasma 6
- Role profiles: `desktop-kde.nix` + `gaming.nix`
- Current host entry: `hosts/nixos/configuration.nix`

## Lenovo ThinkPad C13 Yoga Chromebook Gen 1

- Managed hostname: `thinkpad-c13`
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

- Desktop environment: GNOME
- CPU: Intel Core i7, 13th generation
- Dedicated GPU: NVIDIA GeForce RTX 4060 Laptop GPU
- Intended profiles: `laptop-gnome.nix` + `gaming.nix`
- This is a hybrid Intel/NVIDIA laptop. Do not copy a generic PRIME configuration from another machine: the Intel and NVIDIA PCI bus IDs must be read from this laptop first.
- Host entry and NVIDIA PRIME/offload settings will be added after its actual hostname, boot mode, existing `system.stateVersion`, and GPU PCI addresses are confirmed.

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
