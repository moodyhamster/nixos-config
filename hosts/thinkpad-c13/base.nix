{ ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/common.nix
    ../../profiles/laptop.nix
    ../../profiles/hardware/thinkpad-c13.nix
  ];

  networking.hostName = "thinkpad-c13";

  # Keep a dedicated direct Ethernet link to the PS3 while Wi-Fi remains the
  # laptop's default route to the internet.
  networking.networkmanager.ensureProfiles.profiles.ps3-direct = {
    connection = {
      id = "ps3-direct";
      type = "ethernet";
      interface-name = "enp4s0f3u3c2";
      autoconnect = true;
    };

    ipv4 = {
      method = "manual";
      addresses = "192.168.50.1/24";
      never-default = true;
    };

    ipv6.method = "disabled";
  };

  # Serve the PS3 Flash Writer over plain HTTP on the LAN while the ThinkPad
  # handles the modern HTTPS connection to GitHub Pages upstream.
  services.nginx = {
    enable = true;

    virtualHosts."ps3-flash-writer" = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 8080;
        }
      ];

      locations."/" = {
        proxyPass = "https://xxevilnatxx.github.io/flash-writer/";
        extraConfig = ''
          proxy_ssl_server_name on;
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];

  # Keep the value from this machine's original installation.
  system.stateVersion = "26.05";
}
