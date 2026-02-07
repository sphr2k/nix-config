{
  description = "jan's nix-darwin + home-manager dotfiles";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs =
    inputs@{
      self,
      nixpkgs-unstable,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      darwinSystem = "aarch64-darwin";
      linuxSystem = "x86_64-linux";

      darwinPkgs = nixpkgs-unstable.legacyPackages.${darwinSystem};
      linuxPkgs = nixpkgs-unstable.legacyPackages.${linuxSystem};

      # Shared home-manager config (same modules as darwin host).
      homeModules = [
        ./hosts/mac/home.nix
      ];
    in
    {
      formatter.${darwinSystem} = darwinPkgs.nixfmt;
      formatter.${linuxSystem} = linuxPkgs.nixfmt;

      darwinConfigurations = {
        mac = nix-darwin.lib.darwinSystem {
          system = darwinSystem;
          specialArgs = { inherit inputs self; };
          modules = [
            ./hosts/mac/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
          ];
        };
      };

      nixosConfigurations = {
        linux = nixpkgs-unstable.lib.nixosSystem {
          system = linuxSystem;
          specialArgs = { inherit inputs self; };
          modules = [
            ./hosts/linux/configuration.nix
          ];
        };
      };

      packages.${linuxSystem} = {
        # build a nixos rootfs tarball you can `docker import`
        dockerTarball = self.nixosConfigurations.linux.config.system.build.tarball;
      };

      # Standalone home-manager configs so you can test without touching your real home.
      # Usage: HOME=/tmp/hm-test nix run .#homeConfigurations.test@mac.activationPackage
      # Then: HOME=/tmp/hm-test /tmp/hm-test/.nix-profile/bin/fish
      homeConfigurations = {
        "test@mac" = home-manager.lib.homeManagerConfiguration {
          pkgs = darwinPkgs;
          modules = homeModules
            ++ [
              {
                home.username = "test";
                home.homeDirectory = "/tmp/hm-test";
              }
            ];
          extraSpecialArgs = { inherit inputs; };
        };
        "nix@ubuntu" = home-manager.lib.homeManagerConfiguration {
          pkgs = linuxPkgs;
          modules = homeModules
            ++ [
              ({ lib, ... }: {
                home.username = lib.mkForce "nix";
                home.homeDirectory = lib.mkForce "/home/nix";
              })
            ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
    };
}
