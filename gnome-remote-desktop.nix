{ config, pkgs, ... }:

{
  services.gnome.gnome-remote-desktop.enable = true;

  networking.firewall.allowedTCPPorts = [ 3389 ];

  systemd.services.gnome-remote-desktop = {
    wantedBy = [ "graphical.target" ];
  };
}
