{ ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/common.nix
    ../../profiles/laptop-gnome.nix
    ../../profiles/gaming.nix
  ];

  networking.hostName = "rog-strix-g16";

  users.users.jason = {
    isNormalUser = true;
    description = "jason";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # ASUS ROG Strix G16 (2023), model G614JV.
  # Intel Core i7-13650HX with Intel UHD iGPU + NVIDIA RTX 4060 Laptop GPU.
  # The generated hardware configuration remains local in /etc/nixos.

  # Existing UEFI bootloader configuration from this machine.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hybrid Intel/NVIDIA graphics. PRIME offload keeps GNOME on the Intel iGPU
  # by default and lets games/apps use the RTX 4060 with `nvidia-offload`.
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

  # Keep SSH available so this laptop can be managed remotely.
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  # Keep the value from this machine's original installation.
  system.stateVersion = "26.05";
}
