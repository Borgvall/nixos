{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    {
      nixosConfigurations = {
        johannes-pc = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/johannes-pc/configuration.nix
            ./configuration.nix
            ./ai.nix
            ./gaming.nix
          ];
        };
      };
    };
}
