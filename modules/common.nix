{ pkgs, ... }:

{
  # Settings shared by every NixOS machine, regardless of desktop or hardware.
  networking.networkmanager.enable = true;

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

  # PipeWire audio.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.jason = {
    isNormalUser = true;
    description = "jason";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  programs.firefox.enable = true;
  programs.steam.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Apps/tools deliberately shared across all of Jason's machines.
  # KDE/GNOME desktop-specific apps belong in their desktop profiles instead.
  environment.systemPackages = with pkgs; [
    git
    gh
    brave
    discord
    librewolf
    lutris
    sticky
    proton-vpn
  ];
}
