{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "uta-laptop";

  system.stateVersion = "26.11";

  hostSpecifics.preferVulkan = false;
  hostSpecifics.interfaceNames.eth = "enp1s0";

  services.xserver.xkb.variant = "nodeadkeys,neo";

  users.users.uta = {
    description = "Uta Röhl";
    isNormalUser = true;
    uid = 1011;
  };

  programs.thunderbird = {
    enable = true;
    languagePacks = ["de"];
  };
}
