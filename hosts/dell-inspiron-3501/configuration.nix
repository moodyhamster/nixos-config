{ ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/common.nix
    ../../profiles/laptop-gnome.nix
  ];

  networking.hostName = "dell-inspiron-3501";

  # Preserve the existing account on this laptop.
  users.users.val = {
    isNormalUser = true;
    description = "val";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Dell Inspiron 3501
  # Intel Core i7-1165G7 with integrated Intel Iris Xe graphics.
  # The generated hardware configuration remains local in /etc/nixos.

  # Existing UEFI bootloader configuration from this machine.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Intel Iris Xe uses the normal in-kernel graphics driver; no proprietary
  # GPU configuration is needed.
  hardware.graphics.enable = true;

  # Keep SSH available so this laptop can be managed remotely.
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  # Keep the value from this machine's original installation.
  system.stateVersion = "26.05";
}
