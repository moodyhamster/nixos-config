{ pkgs, ... }:

{
  # Gaming applications that are useful only on gaming-class machines.
  environment.systemPackages = with pkgs; [
    wineWowPackages.stable
    winetricks
  ];
}
