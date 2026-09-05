{ ... }:

{
  imports = [
    # Always keep this machine's generated hardware file local. Never copy one
    # physical machine's hardware-configuration.nix to another machine.
    /etc/nixos/hardware-configuration.nix
    ../../modules/common.nix

    # Desktop environment convention:
    # - laptops use GNOME
    # - desktops use KDE Plasma
    # Uncomment the one that matches this machine:
    # ../../profiles/laptop-gnome.nix
    # ../../profiles/desktop-kde.nix

    # Add this too on gaming machines:
    # ../../profiles/gaming.nix

    # If this is a model we already manage, reuse its shared model profile:
    # ../../profiles/hardware/thinkpad-c13.nix
    # ../../profiles/hardware/rog-strix-g16.nix
    # ../../profiles/hardware/dell-inspiron-3501.nix
    # ../../profiles/hardware/dell-optiplex.nix
  ];

  # Every physical computer must have a unique hostname, even when several
  # machines are the exact same model. Example: thinkpad-c13-2.
  networking.hostName = "CHANGE-ME";

  # Keep the login account specific to this physical machine. Example:
  # users.users.alex = {
  #   isNormalUser = true;
  #   description = "alex";
  #   extraGroups = [ "networkmanager" "wheel" ];
  # };

  # If there is no matching shared model profile yet, put the model-specific
  # bootloader/graphics settings here first, then move reusable settings into
  # profiles/hardware/<model>.nix when the model is known-good.

  # IMPORTANT: copy this value from THIS machine's existing configuration.nix.
  # Do not raise it just because NixOS was upgraded later.
  # system.stateVersion = "26.05";
}
