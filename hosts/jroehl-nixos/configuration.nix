{ pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "jroehl-nixos";

  system.stateVersion = "26.11";

  hostSpecifics.preferVulkan = false;

  hostSpecifics.extraPrograms = {
    internet = false;
    development = true;
  };
}
