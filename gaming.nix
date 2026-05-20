{ config, lib, pkgs, ... }:

{
  boot.kernelModules = [ "ntsync" ];

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
    #remotePlay.openFirewall = true; # Optional: Für Steam Remote Play
    #dedicatedServer.openFirewall = true; # Optional: Für Source Dedicated Server
  };

  # Link the Proton-GE nix store path to the user directory.
  # This is needed for using nixpkgs' proton-ge-bin with Heroic and others.
  #
  # Discussion: https://discourse.nixos.org/t/using-proton-ge-bin-package-outside-of-steam/77598/2
  systemd.user.tmpfiles =  {
    enable = true; # Let this fail, if someone changes the default.
    rules = let 
      steaminstalldir = "%h/.local/share/Steam";
      compatdir = "${steaminstalldir}/compatibilitytools.d";
      link = "${compatdir}/Proton-GE";
      target = pkgs.proton-ge-bin.steamcompattool.outPath;
      steamdir = "%h/.steam";
    in [
      "d ${compatdir} - - - - -"
      "L+ ${link} - - - - ${target}"

      # When Steam gets started for the first time, it creates a directory with
      # symlinks to the install directory (among other things). Third party
      # tools are using these to find Proton versions.
      "d ${steamdir} - - - - -"
      "L ${steamdir}/root - - - - ${steaminstalldir}"
      "L ${steamdir}/steam - - - - ${steaminstalldir}"
    ];
  };

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  environment.systemPackages = with pkgs; [
    heroic
    (bottles.override { removeWarningPopup = true; })
    mangohud
    winetricks
    wineWow64Packages.staging

    ut1999
  ];
}
