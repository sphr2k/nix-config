{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.username = "jan.werner";
  home.homeDirectory = "/Users/jan.werner";

  imports = [
    ../../modules/scripts.nix
    ../../modules/packages.nix
    ../../modules/env.nix
    ../../modules/kubeswitch.nix
    ../../modules/fish.nix
    ../../modules/mise.nix
  ];

  programs.home-manager.enable = true;

  # do not change after first activation.
  home.stateVersion = "24.05";
}
