{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "agent-lsp";
  version = "0.24.2";

  src = fetchFromGitHub {
    owner = "blackwell-systems";
    repo = "agent-lsp";
    rev = "v${version}";
    hash = "sha256-WSl3/xlN3Re8eN3sy9Zm49ljI0vrmm0YWTEY/wI7ZKY=";
  };

  # entspricht `go install .../cmd/agent-lsp@latest`
  subPackages = [ "cmd/agent-lsp" ];

  vendorHash = "sha256-aBokNk3GGCkMX5UYotiQHzWRKfHF6Tc0EA4hIj5XIKg=";

  meta = with lib; {
    description = "MCP server bridging Language Server Protocol into agent-native workflows";
    homepage = "https://github.com/blackwell-systems/agent-lsp";
    license = licenses.mit;
    mainProgram = "agent-lsp";
  };
}
