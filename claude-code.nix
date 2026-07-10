{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    claude-code
  ];

  programs.vscode.extensions = with pkgs.vscode-extensions; [
    anthropic.claude-code
  ];
}
