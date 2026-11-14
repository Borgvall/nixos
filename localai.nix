{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.hostSpecifics.extraFeatures.localai {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "8192";
    };
  };
}
