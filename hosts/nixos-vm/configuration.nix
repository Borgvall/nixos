{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-vm";

  system.stateVersion = "26.11";

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  hostSpecifics.preferVulkan = false;
  hostSpecifics.interfaceNames.eth = "enp1s0";
}
