{
  pkgs,
  lib,
  config,
  ...
}:

let
  agent-lsp = pkgs.callPackage pkgs/agent-lsp.nix { };

  globalGitignore = pkgs.writeText "global-gitignore" ''
    .*.swp
    result
  '';

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
      core.excludesFile = "${globalGitignore}";
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
    ] ++ lib.optionals config.hostSpecifics.extraPrograms.agenticDevelopment [
      opencode
      agent-lsp
    ]
  );
}
