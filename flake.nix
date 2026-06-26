{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    my-nixpkgs.url = "github:Borgvall/nixpkgs/ut1999-expose-isos";
  };

  outputs = { self, nixpkgs, my-nixpkgs, ... }: let
    pkgs-fork = import my-nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
    module-args = {
      _module.args = {
        inherit pkgs-fork;
      };
    };
  in {
    nixosConfigurations = {
      johannes-pc = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/johannes-pc/configuration.nix
          ./configuration.nix
          ./gaming.nix

          module-args
        ];
      };
    };
  };
}
