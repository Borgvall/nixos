{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  fileSystems."/" = {
    options = [ "compress=zstd" "noatime" ];
  };

  boot.loader.efi.canTouchEfiVariables = lib.mkForce true;

  networking.hostName = "live-usb";

  system.stateVersion = "26.11";

  hostSpecifics.preferVulkan = false;

  hostSpecifics.extraPrograms = {
    internet = false;
    development = true;
  };
}
