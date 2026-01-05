{config, lib, pkgs, ... }:

{
  fileSystems."/" = {
    options = [ "subvol=nixos-root" "compress=zstd" "noatime" ];
  };

  fileSystems."/nix" = {
    options = [ "subvol=nixos-nix" "compress=zstd" "noatime" ];
  };

  fileSystems."/home" = {
    options = [ "subvol=home" "compress=zstd" "noatime" ];
  };
}
