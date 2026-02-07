{ config, pkgs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  imports = [
    ../../modules/darwin.nix
  ];

  users.users."jan.werner" = {
    home = "/Users/jan.werner";
  };

  home-manager.users."jan.werner" = import ./home.nix;

  # do not change after first activation.
  system.stateVersion = 5;
}
