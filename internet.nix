{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    languagePacks = [ "de" ];
  };

  programs.evolution = {
    enable = true;
  };

  # Hint Electron Apps/Chromium to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = 1;

  environment.systemPackages = with pkgs; [
    signal-desktop
    wire-desktop

    chromium
  ];
}
