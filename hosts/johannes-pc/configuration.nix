{ config, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./btrfs-filesystems.nix
      ./haskell-backup.nix
  ];

  networking.hostName = "johannes-pc";

  system.stateVersion = "25.11";
}
