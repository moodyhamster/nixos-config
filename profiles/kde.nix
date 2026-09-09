{ pkgs, ... }:

{
  # KDE Plasma is the desktop environment used by every managed host.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # KDE integration shared by every managed desktop.
  programs.kdeconnect.enable = true;

  # KDE uses Blueman for Bluetooth management.
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
    kdePackages.sddm-kcm
  ];
}
