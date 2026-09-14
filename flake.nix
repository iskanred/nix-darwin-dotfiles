{
  description = "nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, nix-darwin, ... }:
    let
      username = "iskanred";
      hostname = "macbook";
    in
    {
      darwinConfigurations.${hostname} =
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit username;
          };

          modules = [
            ./configuration.nix
          ];
        };
    };
}
