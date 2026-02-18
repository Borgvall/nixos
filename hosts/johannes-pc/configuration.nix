{ config, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./btrfs-filesystems.nix
  ];

  networking.hostName = "johannes-pc";
}
