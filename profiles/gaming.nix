{ pkgs, ... }:

{
  # Gaming applications shared by gaming-capable machines.
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    lutris
  ];
}
