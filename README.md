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

**2. Open a shell on the sprite** – then clone the repo (or push and pull) and run nix:

```bash
sprite console
# or: sprite c
```

**3. Run a one-off command on the sprite** (e.g. after cloning the repo there):

```bash
sprite exec -dir /path/to/dotfiles nix flake check
sprite exec -dir /path/to/dotfiles nix build .#packages.x86_64-linux.dockerTarball
```

useful: `sprite list`, `sprite exec --help`, `sprite checkpoint create` / `sprite restore <id>`.

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

