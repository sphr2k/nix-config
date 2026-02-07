{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    mise
  ];

  # ensure mise shims + env are available in fish
  programs.fish.interactiveShellInit = lib.mkAfter ''
    if type -q mise
      mise activate fish | source
    end
  '';
}
