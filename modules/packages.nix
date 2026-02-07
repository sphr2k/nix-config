# Packages from ~/src/flox/flox-janw/.flox/env/manifest.toml
# Installed as user (home) packages so they follow the same profile as mise/fish.
{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    age
    bottom
    byobu
    coreutils
    crane
    docker
    docker-compose
    eza
    gh
    glab
    inetutils  # hostname for fish prompt
    grype
    helmfile
    jq
    just
    k3d
    k9s
    kind
    krew
    kubectl
    kubectl-df-pv
    kubectl-explore
    kubectl-ktop
    kubectl-neat
    kubectl-node-shell
    kubectl-tree
    kubectl-view-secret
    kustomize
    moor
    pre-commit
    ripgrep
    sops
    step-cli
    stern
    pay-respects
    tenv
    tldr
    wget
    yq-go
  ];
}
