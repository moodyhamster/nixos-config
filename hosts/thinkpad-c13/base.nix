{ ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/common.nix
    ../../profiles/hardware/thinkpad-c13.nix
  ];

  networking.hostName = "thinkpad-c13";

  # Keep the value from this machine's original installation.
  system.stateVersion = "26.05";
}
