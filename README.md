# NixOS configuration

Public multi-host NixOS configuration for the machines in `MACHINES.md`.

KDE Plasma is the default desktop on every host. GNOME is available as a separate build, and only the selected desktop is enabled in the active system configuration.

```text
nixos-config/
├── modules/
│   └── common.nix
├── profiles/
│   ├── kde.nix
│   ├── gnome.nix
│   ├── gaming.nix
│   └── hardware/
├── hosts/
│   ├── dell-optiplex/
│   ├── dell-inspiron-3501/
│   ├── thinkpad-c13/
│   ├── rog-strix-g16/
│   └── _template/
├── MACHINES.md
├── update-nixos-config.sh
├── switch-desktop.sh
└── sync-clock.sh
```

## Common configuration

`modules/common.nix` contains settings and applications used across all managed hosts, including networking, OpenSSH remote access, audio, printing, browsers, Git/GitHub CLI, Codex, `lm_sensors`, LibreOffice, qBittorrent, Lutris, Steam, Sticky, Proton VPN and the system helper commands.

OpenSSH is enabled on every managed host and the SSH firewall port is opened by the shared configuration.

The single managed login account is `kim`, with membership in `networkmanager` and `wheel`. Passwords are set locally and are never stored in Git. `users.mutableUsers = true` keeps locally set passwords mutable across rebuilds.

## Desktop profiles

- `profiles/kde.nix` enables KDE Plasma 6 and SDDM and defaults to Breeze Dark.
- `profiles/gnome.nix` enables GNOME and GDM, enables Desktop Icons NG, and defaults to GNOME's dark style.
- `hosts/<hostname>/kde.nix` imports the host base plus the KDE profile.
- `hosts/<hostname>/gnome.nix` imports the host base plus the GNOME profile.

The selected desktop is stored locally in `/etc/nixos/desktop-environment` and is not committed to Git.

Switch desktops with:

```bash
nixos-switch-desktop gnome
```

or:

```bash
nixos-switch-desktop kde
```

## Updates

Normal updates use one machine-wide checkout at `/var/lib/nixos-config`:

```bash
nixos-update
```

If the checkout does not exist, the updater clones the public repository there. Later runs pull the same checkout, detect the current hostname and selected desktop, and rebuild the matching host configuration.

The repository is public, so cloning and pulling do not require GitHub authentication. Authentication is only required to push changes.

## Sync Clock

After a rebuild, the clock helper is available system-wide:

```bash
sync-clock
```

## Host layout

Every physical machine has its own host directory:

```text
hosts/<hostname>/
├── base.nix
├── kde.nix
├── gnome.nix
└── configuration.nix
```

`base.nix` imports the machine's generated `/etc/nixos/hardware-configuration.nix`, `modules/common.nix`, the appropriate hardware profile, and any machine-specific profiles. Each physical machine must keep its own generated hardware configuration; never copy another machine's file.

`system.stateVersion` stays at the value from that machine's original installation unless there is a specific reason to change it.

## Adding another machine

For another machine of an existing model, copy the matching host directory, give it a unique hostname, and verify its original `system.stateVersion`. Identical machines can use numbered hostnames such as `thinkpad-c13-2`.

For a new model, start with `hosts/_template/`, then move reusable bootloader, graphics or service settings into `profiles/hardware/<model>.nix` once the machine is working.

A personal clone is optional for normal updates. If one is wanted for editing or pushing:

```bash
git clone https://github.com/moodyhamster/nixos-config.git ~/nixos-config
```
