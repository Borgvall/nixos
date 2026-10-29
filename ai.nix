{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "8192";
    };
  };

  environment.systemPackages = with pkgs; [
    alpaca
  ];
}
