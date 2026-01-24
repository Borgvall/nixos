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
in
lib.mkMerge [
  (haskell-backup-service "backup-intern")
  (haskell-backup-service "backup")
  (haskell-backup-service "backup-2TB")
]
