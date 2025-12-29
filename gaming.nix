{ config, lib, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
    #remotePlay.openFirewall = true; # Optional: Für Steam Remote Play
    #dedicatedServer.openFirewall = true; # Optional: Für Source Dedicated Server
  };
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  environment.systemPackages = with pkgs; [
    heroic
    bottles
    winetricks
    wineWow64Packages.staging
  ];
}
