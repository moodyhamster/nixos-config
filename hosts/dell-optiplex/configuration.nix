{ ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/common.nix
    ../../profiles/desktop-kde.nix
    ../../profiles/gaming.nix
    ../../profiles/hardware/dell-optiplex.nix
  ];

  # Physical-machine identity stays here; model-wide settings live in the
  # shared Dell OptiPlex hardware profile above.
  networking.hostName = "dell-optiplex";

  # This machine was first installed on NixOS 26.05.
  system.stateVersion = "26.05";
}
