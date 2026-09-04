# Compatibility entry point for the original machine named "nixos".
#
# New multi-machine management lives under hosts/<hostname>/configuration.nix.
# The updater script automatically selects the host that matches the current
# machine's hostname.

{ ... }:

{
  imports = [
    ./hosts/nixos/configuration.nix
  ];
}
