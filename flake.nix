{
  description = "nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

     home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hm-dotfiles = {
      url = "github:iskanred/nix-hm-dotfiles";

      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

outputs =
  {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    hm-dotfiles,
    ...
  }:
  let
    local = import ./local.nix;

    mkDarwin =
      {
        hostname,
        username,
        system,
        homeDirectory
      }:
      nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit local;
        };

        modules = [
          ./configuration.nix

          home-manager.darwinModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = {
              inherit local;
            };

            home-manager.users.${username}.imports = [
              hm-dotfiles.homeModules.default
            ];
          }
        ];
      };
  in
  {
    darwinConfigurations.current = mkDarwin local;
  };
}
