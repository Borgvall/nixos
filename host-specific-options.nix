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
    extraPrograms = {
      internet = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Install additional internet programs.";
      };
      development = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Install additional development tools.";
      };
    };
    extraFeatures = {
      ai = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "If the host runs local AI services";
      };
      gaming = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "If the host is used for gaming";
      };
      officejet = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Support OfficeJet 6950 all in one device";
      };
    };
  };
}
