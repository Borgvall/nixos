{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
  };

  outputs =
    { nixpkgs, ... }:
    {
      nixosConfigurations = {
        johannes-pc = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/johannes-pc/configuration.nix
            ./configuration.nix
          ];
        };
        nixos-vm = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/nixos-vm/configuration.nix
            ./configuration.nix
          ];
        };
        uta-laptop = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/uta-laptop/configuration.nix
            ./configuration.nix
          ];
        };
      };
    };
}
