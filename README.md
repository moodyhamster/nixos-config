# NixOS configuration

This repository stores Jason's managed NixOS configuration.

## First-time setup on a NixOS machine

Clone the repository:

```bash
git clone https://github.com/moodyhamster/nixos-config.git ~/nixos-config
```

Copy that machine's generated hardware configuration into the repo directory. It is ignored by Git, so it stays local to that PC:

```bash
cp /etc/nixos/hardware-configuration.nix ~/nixos-config/hardware-configuration.nix
```

Rebuild directly from the GitHub-managed configuration:

```bash
sudo nixos-rebuild switch -I nixos-config="$HOME/nixos-config/configuration.nix"
```

## Updating later

```bash
cd ~/nixos-config
git pull
sudo nixos-rebuild switch -I nixos-config="$HOME/nixos-config/configuration.nix"
```

`hardware-configuration.nix` is intentionally ignored by Git because it can contain machine-specific disk UUIDs and filesystem settings.
