{
  pkgs,
  ...
}:

{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = [ "kantine" "johannes" ];
    ensureUsers = [
      {
        name = "johannes";
        ensurePermissions = {
          "kantine.*" = "ALL PRIVILEGES";
          "johannes.*" = "ALL PRIVILEGES";
        };
      }
      {
        name = "kantine";
        ensurePermissions = {
          "kantine.*" = "ALL PRIVILEGES";
        };
      }
    ];
    settings = {
      mysqld = {
        bind-address = "127.0.0.1";
      };
    };
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
