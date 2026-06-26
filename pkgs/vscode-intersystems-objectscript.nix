{ vscode-utils
, autoPatchelfHook
, stdenv
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-objectscript";
    publisher = "intersystems-community";
    version = "3.8.2";
    hash = "sha256-RuqRkEz4le6ryZVfQzrzpgea4K6xOcXEONBKd6WpRQQ=";
  };

  nativeBuildInputs = [ 
    autoPatchelfHook 
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];
}
