{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.hostSpecifics.extraFeatures.multimedia {
  environment.systemPackages = with pkgs; [
    rhythmbox
    celluloid
    geeqie
    mpv
    yt-dlp
  ];
}
