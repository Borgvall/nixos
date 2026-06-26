{ ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./btrfs-filesystems.nix
      ./haskell-backup.nix
      ./ai.nix
  ];

  networking.hostName = "johannes-pc";

  hardware.cpu.amd.updateMicrocode = true;

  system.stateVersion = "25.11";

  hostSpecifics.interfaceNames = {
    wlan = "wlo1";
    eth = "enp34s0";
  };
}
