{ pkgs, config, ... }:

{
  programs.direnv = {
    enable = true;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs.enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  environment.systemPackages =
    if config.hostSpecifics.extraPrograms.development
    then with pkgs; [
      ghc
      nixfmt
      gh
    ]
    else [
    ];
}
