{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:Borgvall/nixpkgs/assert-podman-user";
  };

  outputs = { nixpkgs, ... }:
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
