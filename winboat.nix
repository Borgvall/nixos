{ config, lib, pkgs, ... }:

{
  virtualisation.podman.enable = true;
  environment.systemPackages = [
    pkgs.winboat
  ];
}
