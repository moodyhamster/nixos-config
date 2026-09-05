{ ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/common.nix
    ../../profiles/laptop-gnome.nix
    ../../profiles/gaming.nix
    ../../profiles/hardware/rog-strix-g16.nix
  ];

  # Physical-machine identity stays here; model-wide settings live in the
  # shared ROG Strix G16 hardware profile above.
  networking.hostName = "rog-strix-g16";

  users.users.jason = {
    isNormalUser = true;
    description = "jason";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Keep the value from this machine's original installation.
  system.stateVersion = "26.05";
}
