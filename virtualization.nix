{
  config,
  lib,
  ...
}:

lib.mkIf config.hostSpecifics.extraFeatures.virtualization {
  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
}
