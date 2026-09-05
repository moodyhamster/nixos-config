{ ... }:

{
  # KDE is the repository-wide default desktop for now. The updater can follow
  # a machine-local GNOME/KDE selection after switch-desktop.sh is used.
  imports = [
    ./kde.nix
  ];
}
