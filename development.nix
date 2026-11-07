{
  pkgs,
  lib,
  config,
  ...
}:

let
  agent-lsp = pkgs.callPackage pkgs/agent-lsp.nix { };
in
{
  programs.direnv = {
    enable = config.hostSpecifics.extraPrograms.development;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs.enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
      user = {
        name = "Johannes Röhl";
        email = "joroehl@gmx.de";
      };
    };
  };

  environment.systemPackages = lib.optionals config.hostSpecifics.extraPrograms.development (
    with pkgs;
    [
      ghc
      nixfmt
      gh

      #opencode
      agent-lsp
    ]
  );
}
