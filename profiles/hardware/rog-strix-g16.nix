{ ... }:

{
  # Shared settings for ASUS ROG Strix G16 (2023) G614JV machines.
  # Each physical machine still keeps its own generated
  # /etc/nixos/hardware-configuration.nix for UUIDs/filesystems.

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # lspci: 0000:00:02.0 Intel UHD, 0000:01:00.0 NVIDIA RTX 4060.
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };
}
