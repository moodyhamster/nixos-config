{ ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/common.nix
    ../../profiles/laptop.nix
    ../../profiles/hardware/thinkpad-c13.nix
  ];

  networking.hostName = "thinkpad-c13-2";

  # Keep the value from this machine's original installation.
  system.stateVersion = "26.05";
}
