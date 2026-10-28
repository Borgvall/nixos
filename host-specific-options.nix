{ lib, ... }:

{
  options.hostSpecifics = {
    preferVulkan = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "If vulkan is preferred over other APIS as OpenGL, Cuda, RocM.";
    };
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
