# Machine plan

This repository uses shared modules, desktop-role profiles and reusable model-specific hardware profiles. Each physical computer still gets its own `hosts/<hostname>/configuration.nix`.

Desktop environment convention:

- **Laptops use GNOME** via `profiles/laptop-gnome.nix`.
- **Desktops use KDE Plasma** via `profiles/desktop-kde.nix`.

Every managed host has both `jason` and `val` as normal users. Both are members of `networkmanager` and `wheel`, so both can use `sudo`. Passwords are set locally on each machine and are never stored in Git.

Identical machines use unique numbered hostnames such as `thinkpad-c13-2` and `thinkpad-c13-3`.

The generated `/etc/nixos/hardware-configuration.nix` always stays local to each physical machine and is never copied between computers, even when the model/specs are identical.

## Dell OptiPlex desktop

- Managed hostname: `dell-optiplex`
- Users: `jason`, `val`
- Desktop environment: KDE Plasma 6
- Bootloader: GRUB on `/dev/nvme0n1`
- `system.stateVersion`: `26.05`
- Role profiles: `desktop-kde.nix` + `gaming.nix`
- Model profile: `profiles/hardware/dell-optiplex.nix`
- Host entry: `hosts/dell-optiplex/configuration.nix`

## Lenovo ThinkPad C13 Yoga Chromebook Gen 1

- Managed hostname: `thinkpad-c13`
- Users: `jason`, `val`
- Desktop environment: GNOME
- CPU/GPU: AMD Ryzen 5 3500C with integrated Radeon Vega graphics
- Boot mode: UEFI
- Bootloader: systemd-boot
- Storage: NVMe, FAT32 EFI partition mounted at `/boot`, ext4 root filesystem
- `system.stateVersion`: `26.05`
- Role profile: `laptop-gnome.nix`
- Model profile: `profiles/hardware/thinkpad-c13.nix`
- Host entry: `hosts/thinkpad-c13/configuration.nix`
- OpenSSH is enabled for remote access from the local network.
- AMD integrated graphics use the normal in-kernel `amdgpu` stack; no proprietary GPU configuration is needed.

## ASUS ROG Strix G16 (2023)

- Managed hostname: `rog-strix-g16`
- Users: `jason`, `val`
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
- Model profile: `profiles/hardware/rog-strix-g16.nix`
- Host entry: `hosts/rog-strix-g16/configuration.nix`
- NVIDIA's current driver stack is enabled with the open kernel module and PRIME render offload.
- GNOME normally runs on the Intel iGPU; `nvidia-offload <command>` can launch an application on the RTX 4060.
- OpenSSH is enabled for remote access from the local network.

## Dell Inspiron 3501

- Managed hostname: `dell-inspiron-3501`
- Users: `jason`, `val`
- Desktop environment: GNOME
- CPU: Intel Core i7-1165G7
- GPU: Intel Iris Xe Graphics (Tiger Lake-LP GT2), PCI `0000:00:02.0`
- Boot mode: UEFI
- Bootloader: systemd-boot
- Storage: 512 GB NVMe, 1 GB FAT32 EFI partition mounted at `/boot`, ext4 root filesystem
- `system.stateVersion`: `26.05`
- Role profile: `laptop-gnome.nix`
- Model profile: `profiles/hardware/dell-inspiron-3501.nix`
- Host entry: `hosts/dell-inspiron-3501/configuration.nix`
- Intel graphics use the normal in-kernel driver stack; no proprietary GPU configuration is needed.
- OpenSSH is enabled for remote access from the local network.

## Adding an identical machine

Reuse the existing model profile but create a new host entry with a unique hostname. For example, another ThinkPad C13 can use `hosts/thinkpad-c13-2/configuration.nix` while importing the same `profiles/hardware/thinkpad-c13.nix` profile.

Keep the desktop environment based on form factor: GNOME for laptops, KDE Plasma for desktops. Both shared user accounts come from `modules/common.nix` automatically.

Only the physical-machine identity and original `system.stateVersion` belong in the host file. The machine keeps its own `/etc/nixos/hardware-configuration.nix` locally.

## Information to collect from future machines

Useful commands when creating a new host entry:

```bash
hostnamectl --static

grep -R 'system.stateVersion' /etc/nixos/configuration.nix

if [ -d /sys/firmware/efi ]; then echo UEFI; else echo BIOS; fi

lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS

lspci -nnk | grep -A3 -E 'VGA|3D|Display'
```

For a brand-new hardware model, start with settings in that host's configuration. Once the setup is known-good, move reusable bootloader/graphics/SSH settings into `profiles/hardware/<model>.nix` before adding more machines of that model.
