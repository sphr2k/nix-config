{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.username = "jan";
  home.homeDirectory = "/home/jan";

  imports = [
    ../../modules/scripts.nix
    ../../modules/packages.nix
    ../../modules/kubeswitch.nix
    ../../modules/fish.nix
    ../../modules/mise.nix
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "24.05";
}

