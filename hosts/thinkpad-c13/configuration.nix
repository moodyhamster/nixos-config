{ ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/common.nix
    ../../profiles/laptop-gnome.nix
  ];

  networking.hostName = "thinkpad-c13";

  users.users.jason = {
    isNormalUser = true;
    description = "jason";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Lenovo ThinkPad C13 Yoga Chromebook Gen 1
  # AMD Ryzen 5 3500C with integrated Radeon Vega graphics.
  # The generated hardware configuration remains local in /etc/nixos.

  # Existing UEFI bootloader configuration from this machine.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Allow SSH access from the local network. Password authentication follows
  # the system OpenSSH defaults; we can switch to key-only authentication later.
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  # Keep the value from this machine's original installation.
  system.stateVersion = "26.05";
}
