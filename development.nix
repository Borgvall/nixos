{
  pkgs,
  lib,
  config,
  ...
}:

let
  agent-lsp = pkgs.callPackage pkgs/agent-lsp.nix { };
  installExtraPackages = config.hostSpecifics.extraPrograms.development;
in
{
  programs.direnv = {
    enable = installExtraPackages;
  };

  programs.git = {
    enable = true;
    package = if installExtraPackages then pkgs.gitFull else pkgs.git;
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

  environment.systemPackages = lib.optionals installExtraPackages (
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
