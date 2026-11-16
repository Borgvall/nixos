# Old laptop in Impuls
{ pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "jroehl-nixos";

  system.stateVersion = "26.11";

  hostSpecifics.preferVulkan = false;

  programs.evolution.enable = false;

  hostSpecifics.extraPrograms = {
    internet = false;
    development = true;
  };

  hostSpecifics.extraFeatures = {
    multimedia = false;
    officejet = false;
  };

  hostSpecifics.interfaceNames = {
    wlan = "wlp2s0";
    eth = "enp3s0";
  };

  environment.systemPackages = with pkgs; [
    microsoft-edge
  ];
}
