{ ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/common.nix
    ../../profiles/laptop-gnome.nix
    ../../profiles/hardware/dell-inspiron-3501.nix
  ];

  # Physical-machine identity stays here; model-wide settings live in the
  # shared Dell Inspiron 3501 hardware profile above.
  networking.hostName = "dell-inspiron-3501";

  # Keep the value from this machine's original installation.
  system.stateVersion = "26.05";
}
