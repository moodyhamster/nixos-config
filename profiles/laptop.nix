{ pkgs, ... }:

{
  # Applications shared by all laptop-class machines.
  environment.systemPackages = with pkgs; [
    kdePackages.kamoso
  ];
}
