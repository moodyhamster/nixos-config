{ pkgs, ... }:

{
  # KDE Plasma desktop profile. Import this from a host's kde.nix so KDE is
  # the only desktop environment enabled in that system build.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # KDE-specific applications are available to both shared users.
  environment.systemPackages = with pkgs; [
    kdePackages.kate
  ];
}
