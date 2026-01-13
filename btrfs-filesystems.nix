{ config, lib, pkgs, ... }:

let
  commonBtrfsOptions = [ "compress=zstd" "noatime" ];

  createBackupFilesystem = mountpoint: uuid: {
    fileSystems."${mountpoint}" = {
      device = "/dev/disk/by-uuid/${uuid}";
      fsType = "btrfs";
      options = commonBtrfsOptions ++ [ "noauto" ];
    };

    systemd.tmpfiles.rules = [
      "d ${mountpoint} 0755 root root -"
    ];
  };

in
lib.mkMerge [
  {
    fileSystems."/" = {
      options = commonBtrfsOptions;
    };

    fileSystems."/nix" = {
      options = commonBtrfsOptions;
    };

    fileSystems."/home" = {
      options = commonBtrfsOptions;
    };

    fileSystems."/btrfs-root" = {
      device = "/dev/disk/by-uuid/43522f60-718b-4581-a57a-561ba2e745ba";
      fsType = "btrfs";
      options = commonBtrfsOptions;
    };
  }

  (createBackupFilesystem "/backup-intern"     "60d4e5b5-1d3a-4816-bb1c-fc92526ebdfd")
  (createBackupFilesystem "/backup-btrfs"      "431cccce-3c86-4a6d-9c3a-f1ba17433b73")
  (createBackupFilesystem "/backup-btrfs-2TB"  "d24c95ce-a05a-4c55-8e19-b735c8d32fd5")
]
