{ config, lib, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  users.users.johannes.extraGroups = [ "docker" ];
  environment.systemPackages = [
    pkgs.winboat
  ];
}
