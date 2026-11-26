{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "agent-lsp";
  version = "0.24.6";

  src = fetchFromGitHub {
    owner = "blackwell-systems";
    repo = "agent-lsp";
    rev = "v${version}";
    hash = "sha256-HlcTT+uFAVXpDQP+DKmqrnP2nKcR4reqo5IZbeuj8qM=";
  };

  # entspricht `go install .../cmd/agent-lsp@latest`
  subPackages = [ "cmd/agent-lsp" ];

  vendorHash = "sha256-aBokNk3GGCkMX5UYotiQHzWRKfHF6Tc0EA4hIj5XIKg=";

  meta = with lib; {
    description = "MCP server bridging Language Server Protocol into agent-native workflows";
    homepage = "https://agent-lsp.com";
    license = licenses.mit;
    mainProgram = "agent-lsp";
  };
}
