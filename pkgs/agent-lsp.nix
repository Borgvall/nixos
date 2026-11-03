{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "agent-lsp";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "blackwell-systems";
    repo = "agent-lsp";
    rev = "v${version}";
    hash = "sha256-0SNpLduoHKydIuZpd8C7S9tR1HK9YuZSh+Af6V6HBBo=";
  };

  # entspricht `go install .../cmd/agent-lsp@latest`
  subPackages = [ "cmd/agent-lsp" ];

  vendorHash = "sha256-P0BasPcInXymqwzPeLD/O4oicExlBwT0y4z44HIORno=";

  meta = with lib; {
    description = "MCP server bridging Language Server Protocol into agent-native workflows";
    homepage = "https://github.com/blackwell-systems/agent-lsp";
    license = licenses.mit;
    mainProgram = "agent-lsp";
  };
}
