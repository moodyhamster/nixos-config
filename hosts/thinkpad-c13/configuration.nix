{ ... }:

{
  # Default desktop for this host. Use switch-desktop.sh to change the
  # persistent local selection between kde and gnome.
  imports = [
    ./kde.nix
  ];
}
