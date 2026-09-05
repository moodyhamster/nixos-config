{ pkgs, ... }:

{
  # GNOME profile for laptops.
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # GNOME itself does not show files/icons on the desktop. Install and enable
  # GTK4 Desktop Icons NG (DING) so ~/Desktop works on GNOME laptops too.
  environment.systemPackages = with pkgs; [
    gnomeExtensions.gtk4-desktop-icons-ng-ding
  ];

  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/shell" = {
          enabled-extensions = [
            pkgs.gnomeExtensions.gtk4-desktop-icons-ng-ding.extensionUuid
          ];
        };
      };
    }
  ];
}
