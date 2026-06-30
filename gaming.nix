{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.kernelModules = [ "ntsync" ];

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
      dwproton-bin
    ];
    #remotePlay.openFirewall = true; # Optional: Für Steam Remote Play
    #dedicatedServer.openFirewall = true; # Optional: Für Source Dedicated Server
  };

  # Link the Proton nix store paths to the user directory.
  # This is needed for using nixpkgs' protons with Heroic and others.
  #
  # Discussion: https://discourse.nixos.org/t/using-proton-ge-bin-package-outside-of-steam/77598/2
  systemd.user.tmpfiles = {
    enable = true; # Let this fail, if someone changes the default.
    rules =
      let
        steaminstalldir = "%h/.local/share/Steam";
        compatdir = "${steaminstalldir}/compatibilitytools.d";
        steamdir = "%h/.steam";
      in
      [
        "d ${compatdir} - - - - -"

        # When Steam gets started for the first time, it creates a directory with
        # symlinks to the install directory (among other things). Third party
        # tools are using these to find Proton versions.
        "d ${steamdir} - - - - -"
        "L ${steamdir}/root - - - - ${steaminstalldir}"
        "L ${steamdir}/steam - - - - ${steaminstalldir}"
      ]
      ++ map (
        proton:
        let
          link = "${compatdir}/${proton.pname}";
          target = proton.steamcompattool.outPath;
        in
        "L+ ${link} - - - - ${target}"
      ) config.programs.steam.extraCompatPackages;
  };

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  environment.systemPackages = with pkgs; [
    heroic
    mangohud
    winetricks
    wineWow64Packages.staging

    supertuxkart
    ut1999
  ];

  # Keep the Unreal Tournament ISOs in the Nix-store to avoid redownloading them.
  system.extraDependencies = pkgs.ut1999.isos;
}
