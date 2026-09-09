# NixOS configuration

Public multi-host NixOS configuration for the machines in `MACHINES.md`.

KDE Plasma 6 is the desktop environment on every managed host.

```text
nixos-config/
├── modules/
│   └── common.nix
├── profiles/
│   ├── kde.nix
│   ├── gaming.nix
│   ├── laptop.nix
│   └── hardware/
├── hosts/
│   ├── dell-optiplex/
│   ├── dell-optiplex-2/
│   ├── dell-inspiron-3501/
│   ├── thinkpad-c13/
│   ├── thinkpad-c13-2/
│   ├── rog-strix-g16/
│   └── _template/
├── MACHINES.md
├── update-nixos-config.sh
└── sync-clock.sh
```

## Common configuration

`modules/common.nix` contains settings and applications used across all managed hosts, including networking, OpenSSH remote access, audio, printing, browsers, Git/GitHub CLI, Codex, `lm_sensors`, LibreOffice, qBittorrent, Lutris, Steam, Sticky, Proton VPN, VLC, fastfetch and the `nixos-update` helper.

OpenSSH is enabled on every managed host and the SSH firewall port is opened by the shared configuration.

The single managed login account is `kim`, with membership in `networkmanager` and `wheel`. Passwords are set locally and are never stored in Git. `users.mutableUsers = true` keeps locally set passwords mutable across rebuilds.

## KDE Plasma

`profiles/kde.nix` enables KDE Plasma 6 and SDDM, provides the KDE application set, defaults to Breeze Dark, and enables Bluetooth with Blueman.

Each host's `kde.nix` imports its machine base plus the shared KDE profile. GNOME and the desktop-switching helper are not part of this repository.

## Updates

Normal updates use a checkout in the current user's home directory:

```text
~/nixos-config
```

Run updates with:

```bash
nixos-update
```

Run `nixos-update` as the normal user, not with `sudo`; the helper requests `sudo` only for the NixOS rebuild and for a one-time migration when needed.

If `~/nixos-config` does not exist, the updater clones the public repository there. Existing machines that still have the older `/var/lib/nixos-config` checkout are migrated automatically into the home directory and ownership is changed to the current user. Later runs pull the home-directory checkout, detect the current hostname, and rebuild that host's KDE configuration.

The repository is public, so cloning and pulling do not require GitHub authentication. Authentication is only required to push changes. Because the normal checkout is user-owned, no second personal clone is needed for editing.

## Sync Clock

The `sync-clock` helper is installed only on hosts that use `profiles/hardware/dell-optiplex.nix`, so it is available on all managed Dell OptiPlex machines without being installed on laptops or unrelated hosts.

```bash
sync-clock
```

## Host layout

Every physical machine has its own host directory:

```text
hosts/<hostname>/
├── base.nix
├── kde.nix
└── configuration.nix
```

`base.nix` imports the machine's generated `/etc/nixos/hardware-configuration.nix`, `modules/common.nix`, the appropriate hardware profile, and any machine-specific profiles. Each physical machine must keep its own generated hardware configuration; never copy another machine's file.

`kde.nix` imports the host base plus `profiles/kde.nix`. `configuration.nix` is the standard compatibility entry point and imports `kde.nix`.

`system.stateVersion` stays at the value from that machine's original installation unless there is a specific reason to change it.

## Adding another machine

For another machine of an existing model, copy the matching host directory, give it a unique hostname, and verify its original `system.stateVersion`. Identical machines can use numbered hostnames such as `thinkpad-c13-2` or `dell-optiplex-2`.

For a new model, start with `hosts/_template/`, then move reusable bootloader, graphics or service settings into `profiles/hardware/<model>.nix` once the machine is working.

On a fresh installation, the normal checkout location is:

```bash
git clone https://github.com/moodyhamster/nixos-config.git ~/nixos-config
```
