# NixOS configuration

Public multi-host NixOS configuration for the machines documented in `MACHINES.md`. Every managed host uses KDE Plasma 6 and the shared user `kim`.

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
│   ├── thinkpad-c13-3/
│   ├── rog-strix-g16/
│   └── _template/
├── MACHINES.md
├── update-nixos-config.sh
└── sync-clock.sh
```

## Shared configuration

`modules/common.nix` contains settings and applications used by every managed machine. It enables NetworkManager, Avahi, OpenSSH, Tailscale, printing, PipeWire, Steam, and the shared application set.

Shared applications currently include Git, GitHub CLI, Codex, `lm_sensors`, Brave, Discord, LibreWolf, LibreOffice, Zen Browser, qBittorrent, Lutris, Sticky, Proton VPN, VLC, `unrar`, MAME tools (`chdman`), Lufus, fastfetch, Android tools, GNOME Disk Utility, Tailscale, Ventoy, and the `nixos-update` helper.

GNOME Disk Utility is installed as an application only; the GNOME desktop is not enabled. Wine, WinBoat, Docker, Firefox, PokeMMO, GNOME desktop components, and the old desktop-switching helper are not part of the current configuration.

The managed user is `kim`, with `networkmanager` and `wheel` membership. Passwords and other secrets are set locally and must never be committed to this public repository.

## KDE Plasma

`profiles/kde.nix` enables KDE Plasma 6 and SDDM, defaults to Breeze Dark, enables Bluetooth with Blueman, installs Kate, KCalc and KRDC, and opens TCP/UDP port 3389 for KDE Remote Desktop.

Each host's `kde.nix` imports its machine base plus `profiles/kde.nix`.

## Updating a machine

The normal update command uses the shared checkout at `/var/lib/nixos-config`, pulls GitHub, selects the host by its hostname, and rebuilds the matching KDE configuration:

```bash
nixos-update
```

Available modes:

```bash
nixos-update --local    # Rebuild the existing checkout without pulling GitHub.
nixos-update --upgrade  # Pull GitHub, upgrade the configured NixOS channel, then rebuild.
nixos-update --push     # Push existing local commits without rebuilding.
```

Short forms are `-l`, `-u`, and `-p` respectively.

`--local` can still need internet access when Nix must download a package or source that is missing from the local store. `--push` does not stage files or create commits, so uncommitted changes are not included automatically.

The repository is public, so cloning and pulling do not require GitHub authentication. Pushing does. If needed, configure GitHub CLI with `gh auth login` followed by `gh auth setup-git`.

## Host layout

Every physical machine has its own host directory:

```text
hosts/<hostname>/
├── base.nix
├── kde.nix
└── configuration.nix
```

`base.nix` imports that machine's generated `/etc/nixos/hardware-configuration.nix`, `modules/common.nix`, the appropriate hardware profile, and any machine-specific profiles. Never copy another physical machine's generated hardware configuration.

`kde.nix` imports the host base plus `profiles/kde.nix`. `configuration.nix` is the standard compatibility entry point and imports `kde.nix`.

Keep `system.stateVersion` at the value from the machine's original installation unless there is a specific reason to change it.

## Model profiles

Reusable model-specific settings live in `profiles/hardware/`. The Dell OptiPlex profile also installs the `sync-clock` helper:

```bash
sync-clock
```

`profiles/gaming.nix` is intentionally kept as a small placeholder for future gaming-only tuning; shared gaming applications currently live in `modules/common.nix`.

## Adding another machine

For another machine of an existing model, copy the matching host directory, assign a unique hostname, and verify that machine's original `system.stateVersion`. Identical machines may share a model profile, but each keeps its own `/etc/nixos/hardware-configuration.nix`.

For a new model, start with `hosts/_template/`, then move reusable bootloader, graphics, or service settings into `profiles/hardware/<model>.nix` after the machine is working.

A personal clone is optional for normal operation:

```bash
git clone https://github.com/moodyhamster/nixos-config.git ~/nixos-config
```
