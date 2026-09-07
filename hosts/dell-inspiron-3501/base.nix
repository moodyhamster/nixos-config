{ ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/common.nix
    ../../profiles/laptop.nix
    ../../profiles/hardware/dell-inspiron-3501.nix
  ];

  networking.hostName = "dell-inspiron-3501";

  # Keep the value from this machine's original installation.
  system.stateVersion = "26.05";
}
