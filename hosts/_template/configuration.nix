{ ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/common.nix
  ];

  # Change this to the machine's actual hostname.
  networking.hostName = "CHANGE-ME";

  # Add this machine's bootloader settings here.
  # Example for legacy/BIOS GRUB on an NVMe drive:
  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/nvme0n1";
  # boot.loader.grub.useOSProber = true;
  #
  # Example for UEFI systemd-boot:
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
}
