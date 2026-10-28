{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-vm";

  system.stateVersion = "26.11";

  options.hostSpecifics.preferVulkan = false;
}
