{ ... }:

{
  # Shared settings for Lenovo ThinkPad C13 Yoga Chromebook Gen 1 machines.
  # Each physical machine still keeps its own generated
  # /etc/nixos/hardware-configuration.nix for UUIDs/filesystems.

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Expose the built-in accelerometer through iio-sensor-proxy so desktop
  # environments can automatically rotate the display in tablet mode.
  hardware.sensor.iio.enable = true;
}
