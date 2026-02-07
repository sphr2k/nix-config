{ config, pkgs, lib, ... }:

{
  home.username = "jan.werner";
  home.homeDirectory = "/Users/jan.werner";

  programs.home-manager.enable = true;

  # expose repo scripts at ~/scripts (symlinked for fast iteration)
  home.file."scripts" = {
    source = ../../scripts;
    recursive = true;
  };

  home.sessionPath = [
    "$HOME/scripts"
  ];

  home.packages = with pkgs; [
    mise
  ];

  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    set -gx EDITOR nvim
    fish_add_path --path $HOME/scripts

    # mise (https://mise.jdx.dev) - activate shims + env in fish
    if type -q mise
      mise activate fish | source
    end
  '';

  # one small plugin to prove the wiring; expand as you migrate more shell config
  programs.fish.plugins = [
    {
      name = "done";
      src = pkgs.fishPlugins.done;
    }
  ];

  # do not change after first activation.
  home.stateVersion = "24.05";
}

