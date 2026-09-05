# Convenience entry point for the main Dell OptiPlex desktop.
#
# Multi-machine management lives under hosts/<hostname>/configuration.nix.
# The updater script automatically selects the host matching the current
# machine's hostname.

{ ... }:

{
  imports = [
    ./hosts/dell-optiplex/configuration.nix
  ];
}
