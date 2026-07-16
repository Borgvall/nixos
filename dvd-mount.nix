{ ... }:

let
  mountPoint = "/media/dvd";
in
{
  fileSystems.${mountPoint} = {
    device = "/dev/sr0";
    fsType = "auto";
    options = [
      "ro"
      "noauto"
      "users"
      "exec"
      "utf8"
    ];
  };
  systemd.tmpfiles.rules = [ "d ${mountPoint} 0755 root root -" ];
}
