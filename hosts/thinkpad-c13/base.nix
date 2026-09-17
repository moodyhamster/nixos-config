{ ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/common.nix
    ../../profiles/laptop.nix
    ../../profiles/hardware/thinkpad-c13.nix
  ];

  networking.hostName = "thinkpad-c13";

  # Provide a LAN HTTP/HTTPS forward proxy for legacy devices such as the PS3.
  services.squid.enable = true;
  networking.firewall.allowedTCPPorts = [ 3128 ];

  # Keep the value from this machine's original installation.
  system.stateVersion = "26.05";
}
