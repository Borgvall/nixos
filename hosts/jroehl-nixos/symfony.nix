{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    php
    phpactor
    symfony-cli
  ]
  ++ (with pkgs.phpPackages; [
    composer
  ]);
}
