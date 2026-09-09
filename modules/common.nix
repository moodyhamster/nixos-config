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
  # A simple graphical boot splash works with both GRUB and systemd-boot,
  # unlike bootloader settings which remain machine-specific.
  boot.plymouth.enable = true;

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

  programs.firefox.enable = true;
  programs.steam.enable = true;

  # Virtual-machine and container support from the reference configuration.
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.podman.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Make installed fonts visible to applications that need a traditional
  # font directory as well as fontconfig.
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    noto-fonts
  ];

  users.mutableUsers = true;
  users.users.kim = {
    isNormalUser = true;
    description = "kim";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
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

    # Compatible, non-duplicate applications and utilities adapted from the
    # reference KDE configuration.
    wget
    micro
    telegram-desktop
    signal-desktop
    freetube
    rustup
    ruby
    bundler
    blender
    shotcut
    obs-studio
    spotify
    gimp
    synfigstudio
    cava
    parabolic
    heimdall
    adb-sync
    appimage-run
    htop
    fish

    nixosUpdate
  ];
}
