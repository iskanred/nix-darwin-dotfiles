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
      flake = false;
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
    hosts = {
      personal = {
        hostname = "macbook";
        username = "iskanred";
        system = "aarch64-darwin";
      };

      work = {
        hostname = "work-macbook";
        username = "YOUR_WORK_USERNAME";
        system = "aarch64-darwin";
      };
    };

    mkDarwin =
      {
        hostname,
        username,
        system,
      }:
      nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit hostname username system;
        };

        modules = [
          ./configuration.nix

          home-manager.darwinModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = {
              local = {
                inherit username system;
                homeDirectory = "/Users/${username}";
              };
            };

            home-manager.users.${username}.imports = [
              "${hm-dotfiles}/home.nix"
            ];
          }
        ];
      };
  in
  {
    darwinConfigurations = {
      personal = mkDarwin hosts.personal;
      work = mkDarwin hosts.work;
    };
  };
}
