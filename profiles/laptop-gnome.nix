{ pkgs, ... }:

{
  # GNOME profile for laptops.
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Make Desktop Icons NG available in every GNOME session and enable it by
  # default so files and launchers in ~/Desktop are visible on all GNOME hosts.
  services.desktopManager.gnome.sessionPath = [
    pkgs.gnomeExtensions.desktop-icons-ng-ding
  ];

  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/shell" = {
          enabled-extensions = [
            pkgs.gnomeExtensions.desktop-icons-ng-ding.extensionUuid
          ];
        };
      };
    }
  ];
}
