{ ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/common.nix
    ../../profiles/desktop-kde.nix
    ../../profiles/gaming.nix
  ];

  networking.hostName = "dell-optiplex";

  users.users.jason = {
    isNormalUser = true;
    description = "jason";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Host-specific bootloader settings for the Dell OptiPlex desktop.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  # This machine was first installed on NixOS 26.05.
  system.stateVersion = "26.05";
}
