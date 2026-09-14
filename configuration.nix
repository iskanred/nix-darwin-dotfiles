{ username, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = username;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Keep this value after installation unless you deliberately
  # migrate according to the nix-darwin changelog.
  system.stateVersion = 6;
}
