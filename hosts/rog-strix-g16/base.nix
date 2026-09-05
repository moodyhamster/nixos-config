{ ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/common.nix
    ../../profiles/gaming.nix
    ../../profiles/hardware/rog-strix-g16.nix
  ];

  networking.hostName = "rog-strix-g16";

  # Keep the value from this machine's original installation.
  system.stateVersion = "26.05";
}
