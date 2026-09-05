# Compatibility/migration alias for the main desktop's old hostname.
# Once the machine rebuilds, networking.hostName becomes "dell-optiplex" and
# the normal updater will use hosts/dell-optiplex/configuration.nix thereafter.

{ ... }:

{
  imports = [
    ../dell-optiplex/configuration.nix
  ];
}
