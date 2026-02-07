{
  config,
  pkgs,
  lib,
  modulesPath,
  inputs,
  ...
}:

{
  imports = [
    # produces `config.system.build.tarball`
    "${modulesPath}/virtualisation/docker-image.nix"
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    bashInteractive
    coreutils
    findutils
    git
    fish
  ];

  programs.fish.enable = true;

  users.users.jan = {
    isNormalUser = true;
    home = "/home/jan";
    shell = pkgs.fish;
    extraGroups = [ ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.jan = import ./home.nix;

  system.stateVersion = "24.05";
}

