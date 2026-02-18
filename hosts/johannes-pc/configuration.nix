{ config, pkgs, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./btrfs-filesystems.nix
      ./haskell-backup.nix
  ];

  networking.hostName = "johannes-pc";

  environment.systemPackages = with pkgs; [
    ollama-vulkan
    alpaca
  ];

  system.stateVersion = "25.11";
}
