# Fish shell: ensure Nix profile is on PATH before plugins (grc, tide, etc.) run,
# so coreutils, git, etc. are available even when Fish is started without a full login profile.
{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.fish = {
    enable = true;

    # PATH before anything else: config/prompt need whoami, hostname, etc. (minimal envs e.g. sprite)
    shellInit = ''
      set -gx PATH /nix/var/nix/profiles/default/bin $HOME/.nix-profile/bin $PATH
    '';

    # 1. Use the "Nix way" for popular plugins (auto-updated by nix flake update)
    plugins = [
      # Enable Tide (prompt)
      { name = "tide"; src = pkgs.fishPlugins.tide.src; }
      
      # Enable fzf.fish (integration, not just the binary)
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      
      # Essential for compatibility with Bash scripts (nvm, sdkman, etc.)
      { name = "foreign-env"; src = pkgs.fishPlugins.foreign-env.src; }
      { name = "bass"; src = pkgs.fishPlugins.bass.src; }
      
      # Colorize command output
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }

      # -- Custom/Manual Plugins (Use only for things not in nixpkgs) --
      {
        name = "plugin-brew";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-brew";
          rev = "328fc82e1c8e6fd5edc539de07e954230a9f2cef";
          hash = "sha256-ny82EAz0K4XYASEP/K8oxyhyumrITwC5lLRd+HScmNQ=";
        };
      }
      {
        name = "plugin-extract";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-extract";
          rev = "5d05f9f15d3be8437880078171d1e32025b9ad9f";
          hash = "sha256-hFM8uDHDfKBVn4CgRdfRaD0SzmVzOPjfMxU9X6yATzE=";
        };
      }
      {
        name = "plugin-osx";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-osx";
          rev = "27039b251201ec2e70d8e8052cbc59fa0ac3b3cd";
          hash = "sha256-jSUIk3ewM6QnfoAtp16l96N1TlX6vR0d99dvEH53Xgw=";
        };
      }
      {
        name = "onedark-fish";
        src = pkgs.fetchFromGitHub {
          owner = "rkbk60";
          repo = "onedark-fish";
          rev = "5508ddb9b8250567aafcdeb745ceff28039e68ea";
          hash = "sha256-Mma2cRLwR65pthcw8RbReXhj+HpjxeDvRimcVn3IWG8=";
        };
      }
      {
        name = "fish-brew";
        src = pkgs.fetchFromGitHub {
          owner = "halostatue";
          repo = "fish-brew";
          rev = "335d0c56d8ffaf8c060a2242a73ef90412c91e13";
          hash = "sha256-c9LeDMndnOaVA7InMMDe/e5qnAbg/WVqPp9JrNYwnO8=";
        };
      }
      {
        name = "fish-completion-sync";
        src = pkgs.fetchFromGitHub {
          owner = "pfgray";
          repo = "fish-completion-sync";
          rev = "f75ed04e98b3b39af1d3ce6256ca5232305565d8";
          hash = "sha256-wmtMUVi/NmbvJtrPbORPhAwXgnILvm4rjOtjl98GcWA=";
        };
      }
    ];

    # 2. Configure Tide declaratively (optional, avoids the wizard)
    interactiveShellInit = ''
      set -g tide_character_icon "λ"
      set -g tide_prompt_color_separator_same_color 949494
      
      # Configure Tide style
      set -U tide_style Lean
      set -U tide_prompt_colors 'True color'
      set -U tide_show_time No
      set -U tide_lean_prompt_height 'Two lines'
      set -U tide_prompt_connection Solid
      set -U tide_prompt_connection_andor_frame_color Dark
      set -U tide_prompt_spacing Sparse
      set -U tide_icons 'Many icons'
      set -U tide_transient No
    '';
  };

  # 3. Enable Tools via Modules (Fixes PATH issues automatically)
  # These modules inject init scripts with absolute paths to the binaries.
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true; # Autoloads zoxide.fish logic
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  
  # 4. Install the binaries referenced by plugins
  home.packages = with pkgs; [
    grc
    git
    fzf
    bat # Used by fzf.fish for previews
    fd  # Used by fzf.fish for file finding
  ];
}
