## nix dotfiles (nix-darwin + home-manager)

this repo is structured for multiple hosts.

### layout

- `flake.nix`: entrypoint, defines `darwinConfigurations.<host>`
- `hosts/<host>/configuration.nix`: system layer (nix-darwin)
- `hosts/<host>/home.nix`: home layer (home-manager)
- `modules/`: shared modules you can import from hosts later
- `scripts/`: your custom scripts (symlinked into `~/scripts` for now)

### activate (mac)

system activation must run as root. from the repo root:

```bash
export PATH=/nix/var/nix/profiles/default/bin:$PATH
sudo nix --extra-experimental-features 'nix-command flakes' run 'github:LnL7/nix-darwin' -- switch --flake '.#mac'
```

once darwin-rebuild is on your PATH (after a successful switch), you can use:

```bash
sudo darwin-rebuild switch --flake '.#mac'
```

to add another machine later, copy `hosts/mac` to `hosts/<new-host>` and add a new `darwinConfigurations.<new-host>` entry.

### test without touching your home

**1. Build only (no apply)** – check that the config evaluates and builds:

```bash
export PATH=/nix/var/nix/profiles/default/bin:$PATH
nix --extra-experimental-features 'nix-command flakes' run 'github:LnL7/nix-darwin' -- build --flake '.#mac'
```

**2. Run home-manager into a temp directory** – same config, applied to `/tmp/hm-test`:

```bash
export PATH=/nix/var/nix/profiles/default/bin:$PATH
rm -rf /tmp/hm-test
HOME=/tmp/hm-test nix run .#homeConfigurations.test@mac.activationPackage
```

then try the shell:

```bash
HOME=/tmp/hm-test /tmp/hm-test/.nix-profile/bin/fish
```

your real `~` is never used.

### test with sprite (linux vm)

use the [sprite](https://sprites.dev) CLI for a remote linux VM (no Docker seccomp issues).

**1. Pin this repo to your dotfiles sprite** (one-time):

```bash
sprite use -o mail-janwerner-de dotfiles
```

**2. Deploy your home config on the sprite** (from your machine; Nix is installed and repo cloned if missing). Back up existing `~/.config/fish/config.fish` first so standalone home-manager does not refuse to overwrite:

```bash
sprite exec sh -c '
  export PATH=$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH}
  command -v nix >/dev/null || curl -fsSL https://nixos.org/nix/install | sh -s -- --no-daemon --no-modify-profile
  export PATH=$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH}
  [ -d /tmp/nix-config ] || git clone --depth 1 https://github.com/sphr2k/nix-config.git /tmp/nix-config
  mkdir -p $HOME/.config/fish && [ -f $HOME/.config/fish/config.fish ] && mv $HOME/.config/fish/config.fish $HOME/.config/fish/config.fish.bak
  cd /tmp/nix-config && nix run --extra-experimental-features nix-command --extra-experimental-features flakes .#homeConfigurations.sprite@linux.activationPackage
'
```

**3. Use the sprite** – open a login shell. Fish sets PATH in its config (nix + `/usr/bin` etc.); if you use bash first, **prepend** nix so system paths stay:

```bash
sprite console
# If you need to fix PATH in bash (prepend nix, keep /usr/bin):
# export PATH=$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
# then: fish   or  bash -l
```

one-off commands (e.g. flake check):

```bash
sprite exec sh -c 'export PATH=$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH; cd /tmp/nix-config && nix flake check'
```

useful: `sprite list`, `sprite checkpoint create` / `sprite restore <id>`.

### linux docker image (host: linux)

build a docker image tarball (on a linux builder or use sprite for a linux env):

```bash
export PATH=/nix/var/nix/profiles/default/bin:$PATH
nix --extra-experimental-features 'nix-command flakes' build .#packages.x86_64-linux.dockerTarball
```

load and run:

```bash
docker import result/tarball/*.tar.xz dotfiles-linux:latest
docker run --privileged -it --rm dotfiles-linux:latest /init
```

