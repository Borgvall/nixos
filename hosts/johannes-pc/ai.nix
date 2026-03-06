{ config, pkgs, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
  };

  environment.systemPackages = with pkgs; [
    alpaca
  ];
}
