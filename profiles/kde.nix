{ pkgs, ... }:

{
  # KDE Plasma desktop profile. Import this from a host's kde.nix so KDE is
  # the only desktop environment enabled in that system build.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Make Breeze Dark the system-wide Plasma default. Individual users can
  # still choose a different theme in System Settings if they want.
  environment.etc."xdg/kdeglobals".text = ''
    [KDE]
    LookAndFeelPackage=org.kde.breezedark.desktop

    [General]
    ColorScheme=BreezeDark
  '';

  # KDE-specific applications.
  environment.systemPackages = with pkgs; [
    kdePackages.kate
    kdePackages.kcalc
    kdePackages.krdc
  ];
}
