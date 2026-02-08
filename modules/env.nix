# Universal session environment (all hosts). Do not put host-specific vars here.
{ config, pkgs, lib, ... }: {
  home.sessionVariables.TENV_AUTO_INSTALL = "true";
}
