# Jason's NixOS configuration

This private repository is organized for multiple NixOS machines.

```text
nixos-config/
├── configuration.nix              # compatibility entry for the original host
├── modules/
│   └── common.nix                 # settings shared by every machine
├── hosts/
│   ├── nixos/
│   │   └── configuration.nix      # current machine-specific settings
│   └── _template/
│       └── configuration.nix      # starting point for another machine
├── update-nixos-config.sh         # pulls GitHub and rebuilds the current host
└── Update NixOS.desktop           # KDE desktop launcher
```

## What is shared

`modules/common.nix` contains the desktop, user, locale, networking, audio, applications, Git/GitHub CLI and other settings that should be the same on all machines.

## What is machine-specific

Each machine has `hosts/<hostname>/configuration.nix`. This is where its hostname and bootloader settings belong.

The generated `/etc/nixos/hardware-configuration.nix` stays on each computer. It is not committed to GitHub, so disk UUIDs and filesystem details do not get copied between machines.

## First machine: `nixos`

Clone the private repository:

```bash
nix-shell -p git gh
gh auth login
gh repo clone moodyhamster/nixos-config ~/nixos-config
```

Rebuild directly from its host configuration:

```bash
sudo nixos-rebuild switch -I "nixos-config=$HOME/nixos-config/hosts/nixos/configuration.nix"
```

Install the desktop updater:

```bash
chmod +x ~/nixos-config/update-nixos-config.sh
mkdir -p ~/Desktop
cp ~/nixos-config/'Update NixOS.desktop' ~/Desktop/
chmod +x ~/Desktop/'Update NixOS.desktop'
```

## Adding another NixOS machine

Choose a unique hostname, for example `optiplex2`. Clone the repository, then create a host directory from the template:

```bash
cd ~/nixos-config
cp -r hosts/_template hosts/optiplex2
```

Edit `hosts/optiplex2/configuration.nix`, set:

```nix
networking.hostName = "optiplex2";
```

and configure the correct bootloader for that computer. Do not copy another computer's hardware configuration over `/etc/nixos/hardware-configuration.nix`.

For the first rebuild on the new machine, explicitly select that host:

```bash
sudo nixos-rebuild switch -I "nixos-config=$HOME/nixos-config/hosts/optiplex2/configuration.nix"
```

After the rebuild, the machine has its new hostname and `update-nixos-config.sh` will automatically select `hosts/optiplex2/configuration.nix` on future updates.

## Normal updates

The KDE launcher or this command will pull the latest GitHub changes and rebuild the configuration matching the current hostname:

```bash
~/nixos-config/update-nixos-config.sh
```

When changing shared settings, edit `modules/common.nix`. When changing only one computer, edit that computer's file under `hosts/`.
