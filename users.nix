{...}:

{
  users.users.johannes = {
    isNormalUser = true;
    extraGroups = [
      "libvirtd"
      "wheel"
    ];
    uid = 1000;
  };

  users.users.test = {
    isNormalUser = true;
    uid = 1001;
  };
}
