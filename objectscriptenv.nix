{pkgs, ...}:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      (pkgs.callPackage ./pkgs/vscode-intersystems-objectscript.nix { })
      (pkgs.callPackage ./pkgs/vscode-intersystems-servermanager.nix { })
      (pkgs.callPackage ./pkgs/vscode-intersystems-language-server.nix { })
    ];
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
