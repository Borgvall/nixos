{ config, pkgs, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
  };

  environment.systemPackages = with pkgs; [
    alpaca
  ];
}
