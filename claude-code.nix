{ pkgs, ... }:
let
  agent-lsp = pkgs.callPackage ./pkgs/agent-lsp.nix {};
in
{
  environment.systemPackages = with pkgs; [
    claude-code
    agent-lsp
    github-mcp-server
  ];

  programs.vscode.extensions = with pkgs.vscode-extensions; [
    anthropic.claude-code
  ];
}
