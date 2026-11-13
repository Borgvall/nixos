{
  pkgs,
  lib,
  config,
  ...
}:

let
  agent-lsp = pkgs.callPackage pkgs/agent-lsp.nix { };

  # Build an older version 2.2.1 of OpenCode until nixpkgs fixes it
  opencode221 = pkgs.callPackage pkgs/opencode221/package.nix { };

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
      python3
      nixfmt
      nixd
      basedpyright
      gh

      opencode221
      agent-lsp
    ]
  );
}
