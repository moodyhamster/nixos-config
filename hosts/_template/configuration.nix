{ ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/common.nix

    # Pick ONE desktop profile:
    # ../../profiles/desktop-kde.nix
    # ../../profiles/laptop-gnome.nix

    # Add this too on machines that should have Steam/Lutris:
    # ../../profiles/gaming.nix
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

  # IMPORTANT: copy this value from the machine's existing configuration.nix.
  # Do not raise it just because NixOS was upgraded later.
  # system.stateVersion = "26.05";
}
