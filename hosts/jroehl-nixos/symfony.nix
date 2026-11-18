{
  pkgs,
  ...
}:

let
  mariadb = pkgs.mariadb;
in
{
  services.mysql = {
    enable = true;
    package = mariadb;
  };

  environment.systemPackages = with pkgs; [
    mycli # MariaDB autocompletions
    php
    phpactor # PHP language server
    symfony-cli
  ]
  ++ (with pkgs.phpPackages; [
    composer
  ]);
}
