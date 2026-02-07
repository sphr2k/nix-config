{ config, pkgs, lib, self, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # basic flake + nix-darwin setup
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # if you use determinate nix, ensure nix-darwin is configured
  # in a supported way (they document the recommended knobs).
  services.nix-daemon.enable = true;

  environment.systemPackages = with pkgs; [
    git
    curl
  ];

  users.users."jan.werner" = {
    home = "/Users/jan.werner";
  };

  home-manager.users."jan.werner" = import ./home.nix;

  system.configurationRevision = lib.mkIf (self ? rev) self.rev;

  # do not change after first activation.
  system.stateVersion = 5;
}
