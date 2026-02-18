{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations = {
      johannes-pc = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/johannes-pc/configuration.nix
          ./configuration.nix
        ];
      };
    };
  };
}
