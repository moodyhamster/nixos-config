{ ... }:

{
  imports = [
    # Always keep this machine's generated hardware file local. Never copy one
    # physical machine's hardware-configuration.nix to another machine.
    /etc/nixos/hardware-configuration.nix
    ../../modules/common.nix

    # Add this on gaming machines:
    # ../../profiles/gaming.nix

    # Reuse a matching shared model profile when available:
    # ../../profiles/hardware/thinkpad-c13.nix
    # ../../profiles/hardware/rog-strix-g16.nix
    # ../../profiles/hardware/dell-inspiron-3501.nix
    # ../../profiles/hardware/dell-optiplex.nix
  ];

  # Every physical computer must have a unique hostname.
  networking.hostName = "CHANGE-ME";

  # The shared configuration creates the managed user kim. Passwords are set
  # locally and are never stored in Git.

  # IMPORTANT: copy this value from THIS machine's original configuration.nix.
  # system.stateVersion = "26.05";
}
