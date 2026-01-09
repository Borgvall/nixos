{ config, lib, pkgs, ... }:

{
  boot.kernelModules = [ "ntsync" ];
  environment.sessionVariables = {
    PROTON_USE_NTSYNC = "1";
    WINE_NTSYNC = "1";
  };

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
    (bottles.override { removeWarningPopup = true; })
    mangohud
    winetricks
    wineWow64Packages.staging

    ringracers
  ];
}
