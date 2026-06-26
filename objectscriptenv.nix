{pkgs, ...}:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      (pkgs.callPackage ./pkgs/vscode-objectscript.nix { })
      (pkgs.callPackage ./pkgs/vscode-intersystems-servermanager.nix { })
    ];
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
