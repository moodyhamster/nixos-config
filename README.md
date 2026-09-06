# Jason's NixOS configuration

This public repository manages multiple NixOS machines with shared settings, reusable hardware profiles, two shared user accounts, and separate GNOME/KDE system configurations for every host.

**KDE Plasma is currently the default desktop on every host.** GNOME remains available as a separate clean NixOS build for any machine.

```text
nixos-config/
├── configuration.nix
├── modules/
│   └── common.nix
├── profiles/
│   ├── kde.nix
│   ├── gnome.nix
│   ├── gaming.nix
│   └── hardware/
│       ├── dell-optiplex.nix
│       ├── dell-inspiron-3501.nix
│       ├── thinkpad-c13.nix
│       └── rog-strix-g16.nix
├── hosts/
│   ├── dell-optiplex/
│   │   ├── base.nix
│   │   ├── kde.nix
│   │   ├── gnome.nix
│   │   └── configuration.nix
│   ├── thinkpad-c13/
│   ├── rog-strix-g16/
│   ├── dell-inspiron-3501/
│   └── _template/
├── MACHINES.md
├── update-nixos-config.sh
├── switch-desktop.sh
├── Update NixOS.desktop
├── sync-clock.sh
└── Sync Clock.desktop
```

## How it is organized

`modules/common.nix` contains settings and applications shared by every machine, including networking, locale, PipeWire, printing, Firefox, Git/GitHub CLI, Codex, `lm_sensors`, Brave, Discord, LibreWolf, LibreOffice Fresh, Zen Browser, qBittorrent, Lutris, Steam, Sticky and Proton VPN.

Every managed host has both `jason` and `val` as normal users. Both accounts are members of `networkmanager`, `wheel` and `shared`, so both can manage networking, use `sudo`, and read/write the shared folder. Passwords are set locally on each machine and are never stored in Git.

Each host creates `/srv/shared` as a machine-local shared folder for `jason` and `val`. The directory uses the `shared` group and default ACLs so new files and folders remain writable by both users.

Desktop environments are isolated into separate NixOS builds:

- `profiles/kde.nix` enables KDE Plasma 6 and SDDM.
- `profiles/gnome.nix` enables GNOME, GDM and Desktop Icons NG (DING).
- A host's `kde.nix` imports only its base configuration plus the KDE profile.
- A host's `gnome.nix` imports only its base configuration plus the GNOME profile.

This means switching desktops does not enable both desktop environments in the active system at the same time. Old packages may remain in `/nix/store` until garbage collection, and user settings in each home directory are preserved.

Reusable model settings live under `profiles/hardware/`. These profiles contain settings shared by machines of the same model, such as bootloader, graphics and SSH configuration.

Each physical machine has a `hosts/<hostname>/base.nix` containing its machine identity, local generated hardware import, shared modules, model profile and original `system.stateVersion`. The generated `/etc/nixos/hardware-configuration.nix` always stays local to that physical computer and is never copied between machines.

## Desktop selection

KDE is the default when a machine has never selected a desktop. To switch a machine to GNOME:

```bash
nixos-switch-desktop gnome
```

To switch it back to KDE:

```bash
nixos-switch-desktop kde
```

A successful switch stores only the word `kde` or `gnome` in `/etc/nixos/desktop-environment`. Future normal updates keep using that selected desktop. The selection file is local to each machine and is not committed to GitHub.

## Normal updates

After the system-wide updater has been installed by a rebuild, either `jason` or `val` can update the machine with:

```bash
nixos-update
```

The updater uses one machine-wide checkout at `/var/lib/nixos-config`. If that checkout does not exist, it automatically clones the public repository there using `sudo`. Future runs pull that same checkout and rebuild the configuration for the current hostname and selected desktop.

Because the repository is public, no GitHub authentication is required for cloning or pulling. Authentication is only needed for pushing changes back to GitHub.

The original repository-local command remains usable for compatibility:

```bash
bash ~/nixos-config/update-nixos-config.sh
```

The updater detects the hostname, reads the local desktop selection, then rebuilds `hosts/<hostname>/kde.nix` or `hosts/<hostname>/gnome.nix`. If no local selection exists, it uses KDE.

The optional desktop launcher can be installed with:

```bash
mkdir -p ~/Desktop
cp ~/nixos-config/'Update NixOS.desktop' ~/Desktop/
chmod +x ~/Desktop/'Update NixOS.desktop'
```

The launcher calls the system-wide `nixos-update` command.

## Cloning on a new machine

A personal clone is no longer required for normal system updates once `nixos-update` is installed. The updater creates `/var/lib/nixos-config` automatically from the public repository.

If you want a personal checkout for editing or pushing changes, clone it normally:

```bash
git clone https://github.com/moodyhamster/nixos-config.git ~/nixos-config
```

## Adding another machine

Every physical computer gets a unique hostname. Identical machines can use numbered names such as `thinkpad-c13-2` and `thinkpad-c13-3`.

For another machine of an already managed model, copy the existing host directory, then change the hostname and verify the original `system.stateVersion`:

```bash
cd ~/nixos-config
cp -r hosts/thinkpad-c13 hosts/thinkpad-c13-2
```

The new physical machine must still keep its own `/etc/nixos/hardware-configuration.nix` locally.

For a completely new model, copy `hosts/_template` and fill in `base.nix`. Once its hardware settings are known-good, reusable model settings can be moved into `profiles/hardware/<model>.nix`.

For the first build on a new host, KDE is the default:

```bash
sudo nixos-rebuild switch -I "nixos-config=$HOME/nixos-config/hosts/MY-HOSTNAME/kde.nix"
```

After the hostname is active and the shared configuration has been rebuilt, use `nixos-update` or `nixos-switch-desktop`.

Because user passwords are not stored in Git, set or change them locally with:

```bash
sudo passwd jason
sudo passwd val
```

For a change that should affect every computer, edit `modules/common.nix`. For KDE on every machine, edit `profiles/kde.nix`. For GNOME on every machine, edit `profiles/gnome.nix`. For one hardware model, edit its file under `profiles/hardware/`. For one physical computer only, edit its host directory under `hosts/`.
