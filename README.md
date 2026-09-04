# NixOS configuration

This repository stores Jason's managed NixOS configuration.

## First-time setup on a NixOS machine

Clone the repository:

```bash
git clone https://github.com/moodyhamster/nixos-config.git ~/nixos-config
```

Copy the machine's generated hardware configuration into the repo directory without committing it:

```bash
cp /etc/nixos/hardware-configuration.nix ~/nixos-config/hardware-configuration.nix
```

Then rebuild using the repository configuration:

```bash
sudo nixos-rebuild switch -I nixos-config=~/nixos-config -I nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos -I nixos=~/nixos-config/configuration.nix
```

For a simpler non-flake workflow, you can instead copy/symlink the managed file into `/etc/nixos` and rebuild normally.

## Updating later

```bash
cd ~/nixos-config
git pull
sudo cp configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch
```

`hardware-configuration.nix` is intentionally ignored by Git because it can contain machine-specific disk UUIDs and filesystem settings.
