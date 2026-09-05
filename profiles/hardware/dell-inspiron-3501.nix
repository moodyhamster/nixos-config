{ ... }:

{
  # Shared settings for Dell Inspiron 3501 machines.
  # Each physical machine still keeps its own generated
  # /etc/nixos/hardware-configuration.nix for UUIDs/filesystems.

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.graphics.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
  };
}
