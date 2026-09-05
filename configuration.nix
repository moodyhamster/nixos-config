# Convenience entry point for the main Dell OptiPlex desktop.
#
# Each managed host has base.nix plus separate kde.nix and gnome.nix builds.
# The host-level configuration.nix remains a KDE-default compatibility entry;
# normal updates use the locally selected desktop through update-nixos-config.sh.

{ ... }:

{
  imports = [
    ./hosts/dell-optiplex/configuration.nix
  ];
}
