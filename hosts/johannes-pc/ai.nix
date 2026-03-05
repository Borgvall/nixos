{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ollama-vulkan
    alpaca
  ];
}
