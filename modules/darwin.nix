{
  config,
  pkgs,
  lib,
  self,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  nix.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # if you use determinate nix, follow their nix-darwin guide so
  # nix-darwin does not try to manage the nix installation layer.

  environment.systemPackages = with pkgs; [
    git
    curl
  ];

  system.configurationRevision = lib.mkIf (self ? rev) self.rev;
}
