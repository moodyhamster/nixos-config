# Jason's NixOS configuration

This private repository manages multiple NixOS machines with shared settings, desktop-role profiles, and one host file per computer.

```text
nixos-config/
├── configuration.nix
├── modules/
│   └── common.nix
├── profiles/
│   ├── desktop-kde.nix
│   ├── laptop-gnome.nix
│   └── gaming.nix
├── hosts/
│   ├── dell-optiplex/
│   │   └── configuration.nix
│   ├── thinkpad-c13/
│   │   └── configuration.nix
│   ├── rog-strix-g16/
│   │   └── configuration.nix
│   ├── dell-inspiron-3501/
│   │   └── configuration.nix
│   └── _template/
│       └── configuration.nix
├── MACHINES.md
├── update-nixos-config.sh
├── Update NixOS.desktop
├── sync-clock.sh
└── Sync Clock.desktop
```

## How it is organized

`modules/common.nix` contains settings and applications wanted on every machine, including networking, locale, PipeWire, printing, Firefox, Git/GitHub CLI, Brave, Discord, LibreWolf, LibreOffice Fresh, Zen Browser, qBittorrent, Lutris, Steam, Sticky and Proton VPN.

User accounts are host-specific so each computer can keep its existing login name. The Dell Inspiron 3501 keeps its existing `val` account; the other currently managed machines use `jason`.

Desktop environments are separate profiles:

- `profiles/desktop-kde.nix` enables KDE Plasma 6 and SDDM.
- `profiles/laptop-gnome.nix` enables GNOME and GDM and enables Desktop Icons NG (DING).
- `profiles/gaming.nix` is reserved for gaming-machine-specific tuning and services.

Each computer gets `hosts/<hostname>/configuration.nix`. That file chooses the right profiles and contains machine-specific settings such as hostname, user account, bootloader, graphics configuration and `system.stateVersion`.

The generated `/etc/nixos/hardware-configuration.nix` stays local to each computer. Do not copy it between machines because it can contain disk UUIDs, filesystem configuration and detected hardware settings.

See `MACHINES.md` for hardware and host details.

## Normal updates

Every configured machine can update itself with:

```bash
bash ~/nixos-config/update-nixos-config.sh
```

The updater pulls GitHub, detects the current hostname, selects `hosts/<hostname>/configuration.nix`, and rebuilds NixOS.

The optional desktop launcher can be installed with:

```bash
mkdir -p ~/Desktop
cp ~/nixos-config/'Update NixOS.desktop' ~/Desktop/
chmod +x ~/Desktop/'Update NixOS.desktop'
```

The launcher runs `update-nixos-config.sh` through Bash, so the repository copy of the shell script does not need to be executable.

## Cloning on a new machine

```bash
nix-shell -p git gh
gh auth login
gh repo clone moodyhamster/nixos-config ~/nixos-config
```

## Adding another machine

Create a new host from the template, then edit it with the machine's real hostname, existing user account, bootloader, hardware-specific options and original `system.stateVersion`.

```bash
cd ~/nixos-config
cp -r hosts/_template hosts/MY-HOSTNAME
```

For the first rebuild on a newly added machine, explicitly select its host file:

```bash
sudo nixos-rebuild switch -I "nixos-config=$HOME/nixos-config/hosts/MY-HOSTNAME/configuration.nix"
```

After the hostname matches its host directory, use the normal updater.

For a change that should affect every computer, edit `modules/common.nix`. For all KDE desktops, edit `profiles/desktop-kde.nix`. For all GNOME laptops, edit `profiles/laptop-gnome.nix`. For one computer only, edit its file under `hosts/`.
