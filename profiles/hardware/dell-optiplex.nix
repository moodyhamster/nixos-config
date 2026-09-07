{ pkgs, ... }:

let
  syncClock = pkgs.writeShellScriptBin "sync-clock"
    (builtins.readFile ../../sync-clock.sh);
in
{
  # Shared setup for the Dell OptiPlex desktop model/layout used here.
  # Each physical machine still keeps its own generated
  # /etc/nixos/hardware-configuration.nix for UUIDs/filesystems.

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  # This helper is only needed on the OptiPlex machines.
  environment.systemPackages = [ syncClock ];
}
