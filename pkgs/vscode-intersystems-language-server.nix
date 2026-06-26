{ lib
, vscode-utils
, autoPatchelfHook
, stdenv
, musl
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "language-server";
    publisher = "intersystems";
    version = "2.8.3";
    hash = "sha256-VjOW/ANCiNfHvKudlHimJy5nrGb14ezXjlWm0xPUon0=";
  };

  nativeBuildInputs = [ 
    autoPatchelfHook 
  ];

  buildInputs = [
    musl
    stdenv.cc.cc.lib
  ];
}
