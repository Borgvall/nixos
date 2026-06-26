{ lib
, vscode-utils
, autoPatchelfHook
, stdenv
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "servermanager";
    publisher = "intersystems-community";
    version = "3.12.3";
    hash = "sha256-OgDWkAYJYFnTC0Iv3zfOJWi/dKomxnxh59auV3UgJ5k=";
  };

  nativeBuildInputs = [ 
    autoPatchelfHook 
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];
}
