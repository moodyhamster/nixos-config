# Jason's NixOS configuration

This private repository manages multiple NixOS machines with shared settings, desktop-role profiles, reusable model-specific hardware profiles, and one host file per physical computer.

```text
nixos-config/
├── configuration.nix
├── modules/
│   └── common.nix
├── profiles/
│   ├── desktop-kde.nix
│   ├── laptop-gnome.nix
│   ├── gaming.nix
│   └── hardware/
│       ├── dell-optiplex.nix
│       ├── dell-inspiron-3501.nix
│       ├── thinkpad-c13.nix
│       └── rog-strix-g16.nix
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

User accounts are host-specific so each physical computer can keep its own login name. The Dell Inspiron 3501 keeps its existing `val` account; the other currently managed machines use `jason`.

Desktop environments are separate profiles:

- `profiles/desktop-kde.nix` enables KDE Plasma 6 and SDDM.
- `profiles/laptop-gnome.nix` enables GNOME and GDM and enables Desktop Icons NG (DING).
- `profiles/gaming.nix` is reserved for gaming-machine-specific tuning and services.

Reusable model settings live under `profiles/hardware/`. These profiles hold settings that should be the same on machines of the same model, such as bootloader setup, graphics configuration and SSH settings.

Each physical computer still gets its own `hosts/<hostname>/configuration.nix`. The host file contains the machine's unique identity: hostname, login user and original `system.stateVersion`, then imports the matching desktop and model profiles.

The generated `/etc/nixos/hardware-configuration.nix` always stays local to each physical computer. Never copy it between machines, even when they are the exact same model, because disk UUIDs, filesystems and detected hardware values can differ.

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

Every physical machine gets a unique hostname. For another machine of a model already managed, use a simple numbered name such as:

```text
thinkpad-c13
thinkpad-c13-2
thinkpad-c13-3
```

For an identical model, copy the existing host entry as a starting point. For example:

```bash
cd ~/nixos-config
cp -r hosts/thinkpad-c13 hosts/thinkpad-c13-2
```

Then change only the physical-machine-specific details in the new host file: `networking.hostName`, the login user, and verify that `system.stateVersion` matches that machine's original installation. Keep the same `profiles/hardware/thinkpad-c13.nix` import when the model/specs match.

For a completely new model, start from the generic template:

```bash
cd ~/nixos-config
cp -r hosts/_template hosts/MY-HOSTNAME
```

Add the machine's desktop profile and hardware settings. Once a model-specific setup is known-good, reusable settings can live in `profiles/hardware/<model>.nix` so later identical machines only need a small host file.

For the first rebuild on a newly added machine, explicitly select its host file:

```bash
sudo nixos-rebuild switch -I "nixos-config=$HOME/nixos-config/hosts/MY-HOSTNAME/configuration.nix"
```

After the hostname matches its host directory, use the normal updater.

For a change that should affect every computer, edit `modules/common.nix`. For all KDE desktops, edit `profiles/desktop-kde.nix`. For all GNOME laptops, edit `profiles/laptop-gnome.nix`. For every machine of one hardware model, edit its file under `profiles/hardware/`. For one physical computer only, edit its file under `hosts/`.
