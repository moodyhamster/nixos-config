# Jason's NixOS configuration

This private repository is organized for multiple NixOS machines with shared settings, desktop-role profiles, and one host file per computer.

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
│   ├── nixos/
│   │   └── configuration.nix
│   └── _template/
│       └── configuration.nix
├── MACHINES.md
├── update-nixos-config.sh
└── Update NixOS.desktop
```

## How it is organized

`modules/common.nix` contains settings and applications wanted on every machine: networking, locale, PipeWire, printing, the `jason` user, Firefox, Git/GitHub CLI, Brave, Discord, LibreWolf, Proton VPN and other common settings.

Desktop environments are separate profiles:

- `profiles/desktop-kde.nix` enables KDE Plasma 6 and SDDM.
- `profiles/laptop-gnome.nix` enables GNOME and GDM.
- `profiles/gaming.nix` enables Steam and installs Lutris.

Each computer gets `hosts/<hostname>/configuration.nix`. That file chooses the right profiles and contains machine-specific settings such as hostname, bootloader and `system.stateVersion`.

The generated `/etc/nixos/hardware-configuration.nix` stays local to each computer. Do not copy it between machines because it can contain disk UUIDs, filesystem configuration and detected hardware settings.

See `MACHINES.md` for the current desktop, ThinkPad C13 Yoga, and ASUS ROG Strix G16 plan.

## Current KDE desktop

The current host is `nixos` and imports the KDE and gaming profiles.

Clone the private repository:

```bash
nix-shell -p git gh
gh auth login
gh repo clone moodyhamster/nixos-config ~/nixos-config
```

Rebuild it with:

```bash
sudo nixos-rebuild switch -I "nixos-config=$HOME/nixos-config/hosts/nixos/configuration.nix"
```

Install the KDE desktop updater:

```bash
mkdir -p ~/Desktop
cp ~/nixos-config/'Update NixOS.desktop' ~/Desktop/
chmod +x ~/Desktop/'Update NixOS.desktop'
```

The launcher runs `update-nixos-config.sh` through Bash, so the script itself does not need `chmod +x`. Keeping the repository copy non-executable avoids Git treating a local mode change as an uncommitted modification.

## Adding another machine

Copy the template into a directory whose name matches that machine's hostname:

```bash
cd ~/nixos-config
cp -r hosts/_template hosts/MY-HOSTNAME
```

Then edit `hosts/MY-HOSTNAME/configuration.nix` to choose either the KDE or GNOME profile, optionally add the gaming profile, configure the correct bootloader, and copy the machine's existing `system.stateVersion` value.

For the first rebuild on that machine:

```bash
sudo nixos-rebuild switch -I "nixos-config=$HOME/nixos-config/hosts/MY-HOSTNAME/configuration.nix"
```

Afterward, `update-nixos-config.sh` automatically detects the hostname, pulls GitHub and rebuilds using the matching host configuration.

## Normal updates

```bash
bash ~/nixos-config/update-nixos-config.sh
```

For a change that should affect every computer, edit `modules/common.nix`. For all KDE desktops, edit `profiles/desktop-kde.nix`. For all GNOME laptops, edit `profiles/laptop-gnome.nix`. For gaming machines, edit `profiles/gaming.nix`. For one computer only, edit its file under `hosts/`.
