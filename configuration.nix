{ local, ... }:

{
  nixpkgs.hostPlatform = local.system;

  system.primaryUser = local.username;

  users.users.${local.username} = {
    name = local.username;
    home = local.homeDirectory;
  };

  system.defaults.dock.show-recents = false;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Keep this value after installation unless you deliberately
  # migrate according to the nix-darwin changelog.
  system.stateVersion = 6;
}
