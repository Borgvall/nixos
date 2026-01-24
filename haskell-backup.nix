{ config, lib, pkgs, ... }:
let
  haskell-backup-service = name: {
    systemd.services."haskell-${name}" = {
      description = "Run Haskell backup script ${name}";
      serviceConfig.Type = "oneshot";
      path = with pkgs; [ ghc btrfs-progs util-linux coreutils ];
      script = ''
        cd /root/haskell-backup
        ./${name}.hs
        '';
    };
  };
  haskell-backup-service-timer = name: let systemd-name = "haskell-${name}"; in {
    systemd.timers.${systemd-name} = {
      description = "Run Haskell backup script ${name} daily";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        RandomizedDelaySec = 1200;
        Persistent = true;
        Unit = systemd-name;
      };
    };
  };
  haskell-backup-service-starts-by-disk-availability = name: uuid:
  let
    escapeHyphen = fileName: lib.replaceStrings ["-"] ["\\x2d"] fileName;
    disk-device = "dev-disk-${escapeHyphen "by-uuid"}-${escapeHyphen uuid}.device";
  in {
    systemd.services."haskell-${name}" = {
      bindsTo = [ disk-device ];
      after = [ disk-device ];
      wantedBy = [ disk-device ];
    };
  };
in
lib.mkMerge [
  (haskell-backup-service "backup-intern")
  (haskell-backup-service-timer "backup-intern")
  (haskell-backup-service "backup")
  (haskell-backup-service-starts-by-disk-availability "backup" "431cccce-3c86-4a6d-9c3a-f1ba17433b73")
  (haskell-backup-service "backup-2TB")
  (haskell-backup-service-starts-by-disk-availability "backup-2TB" "d24c95ce-a05a-4c55-8e19-b735c8d32fd5")
]
