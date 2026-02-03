{ config, lib, pkgs, ... }:
{
  services.borgbackup.jobs."borgremote" = {
    paths = [
      "/home/johannes/Bewerbung"
      "/home/johannes/Dokumente"
    ];
    repo = "ssh://z584s2b5@z584s2b5.repo.borgbase.com/./repo";
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat /run/keys/borgbase_passphrase";
    };
    environment = { BORG_RSH = "ssh -i /run/keys/id_ed25519_borgbase"; };
    startAt = "12:00";
    persistentTimer = true;
  };
}

