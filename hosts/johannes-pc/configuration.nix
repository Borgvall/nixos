{ ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./btrfs-filesystems.nix
      ./haskell-backup.nix
  ];

  networking.hostName = "johannes-pc";

  hardware.cpu.amd.updateMicrocode = true;

  system.stateVersion = "25.11";

  hostSpecifics.interfaceNames = {
    wlan = null; # Disabled for Kernel 7.2.9 issue
    eth = "enp34s0";
  };
}
