{ ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/common.nix
    ../../profiles/gaming.nix
    ../../profiles/hardware/dell-optiplex.nix
  ];

  networking.hostName = "dell-optiplex";

  # This machine was first installed on NixOS 26.05.
  system.stateVersion = "26.05";
}
