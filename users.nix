{
  pkgs,
  ...
}:

{
  programs.fish = {
    enable = true;
  };

  users.users.johannes = {
    description = "Johannes Röhl";
    initialPassword = "12345"; # change it promptly ;-)
    isNormalUser = true;
    extraGroups = [
      "libvirtd"
      "wheel"
    ];
    uid = 1000;
    shell = pkgs.fish;
  };

  users.users.test = {
    isNormalUser = true;
    uid = 1001;
  };
}
