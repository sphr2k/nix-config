## nix dotfiles (nix-darwin + home-manager)

this repo is structured for multiple hosts.

### layout

- `flake.nix`: entrypoint, defines `darwinConfigurations.<host>`
- `hosts/<host>/configuration.nix`: system layer (nix-darwin)
- `hosts/<host>/home.nix`: home layer (home-manager)
- `modules/`: shared modules you can import from hosts later
- `scripts/`: your custom scripts (symlinked into `~/scripts` for now)

### activate (mac)

from the repo root:

```bash
darwin-rebuild switch --flake .#mac
```

to add another machine later, copy `hosts/mac` to `hosts/<new-host>` and add a new `darwinConfigurations.<new-host>` entry.

