{ config, lib, ... }:

{
  # expose repo scripts at ~/scripts (symlinked for fast iteration)
  home.file."scripts" = {
    source = ../scripts;
    recursive = true;
  };

  home.sessionPath = [
    "$HOME/scripts"
  ];
}
