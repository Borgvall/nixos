{ config, lib, pkgs, ... }:

{
  boot.kernelModules = [ "ntsync" ];
  environment.sessionVariables = {
    PROTON_USE_NTSYNC = "1";
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

  system.userActivationScripts.linkProtonGE = {
    text = ''
      TARGET="${pkgs.proton-ge-bin.steamcompattool.outPath}"
      LINK="$HOME/.steam/root/compatibilitytools.d/Proton-GE"
      
      # Create the link only, if it's not correct already.
      if [ ! -L "$LINK" ] || [ "$(readlink -e "$LINK")" != "$TARGET" ]; then
        mkdir -p "$(dirname "$LINK")"
        ln -Tfs "$TARGET" "$LINK"
      fi
    '';
  };

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  environment.systemPackages = with pkgs; [
    heroic
    mangohud
    winetricks
    wineWow64Packages.staging

    ut1999
  ];
}
