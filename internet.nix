{ pkgs, config, ... }:

let
  languagePacks = [ "de" ];
in
{
  programs.firefox = {
    enable = true;
    inherit languagePacks;
  };

  programs.thunderbird = {
    # set `enable = true;` in the host's configuration
    inherit languagePacks;
  };

  programs.evolution = {
    enable = !config.programs.thunderbird.enable;
  };

  # Hint Electron Apps/Chromium to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = 1;

  environment.systemPackages = with pkgs; [
    signal-desktop
    wire-desktop

    chromium
  ];
}
