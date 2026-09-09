{ pkgs, ... }:

let
  # Zen Browser is not currently packaged directly in nixpkgs 26.05.
  # Pin the community Zen packaging repo and import it with this system's pkgs.
  zenBrowserSrc = builtins.fetchGit {
    url = "https://github.com/0xc000022070/zen-browser-flake.git";
    rev = "fdb83f8fce835213fab7eab52c375926fe1a32dc";
  };
  zenBrowser = (import zenBrowserSrc { inherit pkgs; }).default;

  nixosUpdate = pkgs.writeShellScriptBin "nixos-update"
    (builtins.readFile ../update-nixos-config.sh);
in
{
  networking.networkmanager.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  services.tailscale.enable = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.steam.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.mutableUsers = true;
  users.users.kim = {
    isNormalUser = true;
    description = "kim";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    git
    gh
    codex
    lm_sensors
    brave
    discord
    librewolf
    libreoffice-fresh
    zenBrowser
    qbittorrent
    lutris
    sticky
    proton-vpn
    pokemmo-installer
    vlc
    fastfetch
    android-tools
    gnome-disk-utility
    tailscale
    nixosUpdate
  ];
}
