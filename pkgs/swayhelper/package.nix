{ haskellPackages }:

haskellPackages.callCabal2nix "swayhelper" ./. { }
