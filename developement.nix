{ pkgs, ... }:

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

  environment.systemPackages = with pkgs; [
    ghc
    nixfmt
    gh
  ];
}
