{ ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/common.nix
    ../../profiles/laptop-gnome.nix
    ../../profiles/hardware/thinkpad-c13.nix
  ];

  # Physical-machine identity stays here; model-wide settings live in the
  # shared ThinkPad C13 hardware profile above.
  networking.hostName = "thinkpad-c13";

  users.users.jason = {
    isNormalUser = true;
    description = "jason";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Keep the value from this machine's original installation.
  system.stateVersion = "26.05";
}
