{ pkgs, ... }:

{
  # KDE Plasma profile for desktop systems.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # KDE-specific application from the desktop configuration.
  users.users.jason.packages = with pkgs; [
    kdePackages.kate
  ];
}
