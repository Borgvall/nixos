{ config, pkgs, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./btrfs-filesystems.nix
      ./haskell-backup.nix
  ];

  networking.hostName = "johannes-pc";

  hardware.cpu.amd.updateMicrocode = true;

  environment.systemPackages = with pkgs; [
    ollama-vulkan
    alpaca
  ];

  system.stateVersion = "25.11";
}
