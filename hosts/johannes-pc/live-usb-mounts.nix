{ ... }:
{
  fileSystems."/live-usb-root" =
    { device = "/dev/disk/by-uuid/b0ae0310-a748-493e-8d47-cbfe274d1cca";
      fsType = "btrfs";
      options = [ "compress=zstd" "noatime" "ssd_spread" "noauto" ];
    };
  systemd.tmpfiles.rules = [
    "d /live-usb-root 0755 root root -"
  ];

  fileSystems."/live-usb-root/boot" =
    { device = "/dev/disk/by-uuid/12CE-A600";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" "noauto" ];
    };
}
