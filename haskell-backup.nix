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
in
lib.mkMerge [
  (haskell-backup-service "backup-intern")
  (haskell-backup-service-timer "backup-intern")
  (haskell-backup-service "backup")
  (haskell-backup-service "backup-2TB")
]
