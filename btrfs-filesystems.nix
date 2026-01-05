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

  fileSystems."/btrfs-root" = {
    device = "/dev/disk/by-uuid/43522f60-718b-4581-a57a-561ba2e745ba";
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" ];
  };

  fileSystems."/backup-intern" = {
    device = "/dev/disk/by-uuid/60d4e5b5-1d3a-4816-bb1c-fc92526ebdfd";
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" "noauto" ];
  };

  fileSystems."/backup-btrfs" = {
    device = "/dev/disk/by-uuid/431cccce-3c86-4a6d-9c3a-f1ba17433b73";
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" "noauto" ];
  };

  fileSystems."/backup-btrfs-2TB" = {
    device = "/dev/disk/by-uuid/d24c95ce-a05a-4c55-8e19-b735c8d32fd5";
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" "noauto" ];
  };

  # Create mount points for backup filesystems
  systemd.tmpfiles.rules = [
    "d /backup-intern 0755 root root -"
    "d /backup-btrfs 0755 root root -"
    "d /backup-btrfs-2TB 0755 root root -"
  ];
}
