# AGENT.md - Dotfiles Agent Rules

## Goal
Make this repo a reproducible macOS dev environment using:
- nix-darwin for system layer
- home-manager for home directory layer
- fish as the interactive shell
- mise for language runtimes
- scripts/ as user commands

## Repo invariants
- Keep host-specific data minimal in `hosts/<host>/`.
- Put almost all configuration in `modules/` and import it from host files.
- Never hardcode absolute paths except `/Users/<name>` and only inside host glue.
- Prefer declarative Nix options over shell scripts.
- Do not add new tools unless requested.

## Formatting and style
- Use " - " instead of em dash/en dash.
- Avoid curly quotes.

## Change policy
- Any change must be minimal, buildable, and reversible.
- After editing Nix files, run:
  - `nix fmt` (if configured)
  - `nix flake check` (if it exists)
  - `darwin-rebuild build --flake .#mac` before suggesting `switch`

## Fish and plugins
- Prefer `programs.fish` and `programs.fish.plugins` via home-manager.
- Avoid Fisher unless explicitly requested (it introduces mutable state).

## Scripts
- Scripts live in `scripts/`.
- Start by exposing scripts via `home.file` + `home.sessionPath`.
- If a script needs dependencies, convert it to a Nix `writeShellApplication` later.

## Mise
- Install `mise` via Nix.
- Activate mise from fish using `mise activate fish | source`.
- Runtime versions belong in project repos via `mise.toml`, not in this repo.

## Environment (universal)
- Universal session variables live in `modules/env.nix` (imported by all hosts).
- Do not put env vars in host-specific config; add them to `env.nix` so they apply everywhere.
- Example: `TENV_AUTO_INSTALL=true` for tenv is set in `modules/env.nix`.
