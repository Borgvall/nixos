{ config, lib, options, ... }:

{
  options.hostSpecifics = {
    interfaceNames = {
      wlan = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Name of WLAN interface, null means no such interface exists.";
      };
      eth = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Name of ethernet interface, null means no such interface exists.";
      };
    };
  };
}
