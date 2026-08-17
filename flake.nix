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
            #./ai.nix
            ./gaming.nix
          ];
        };
      };
    };
}
