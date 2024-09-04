{
  description = "My Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Rust
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Darwin
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # deploy-rs
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake Parts
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
  };

  outputs = inputs @ {
    self,
    deploy-rs,
    nixos-flake,
    ...
  }:
    (import ./shim.nix) inputs (shim: {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
      imports = [
        nixos-flake.flakeModule
        ./config.nix
        ./unit
        ./system/darwin
        ./system/nixos-desktop
        ./system/nixos-server
      ];

      flake = with shim; {
        checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
        nixosConfigurations = {
          Atlas = mkLinuxSystem machine/Atlas;
          Everest = mkLinuxSystem machine/Everest;
          Colden = mkLinuxSystem machine/Colden;
        };
        darwinConfigurations = {
          Fuji = mkMacosSystem machine/Fuji;
        };
        deploy.nodes = {
          Colden = mkLinuxDeploy "Colden" "colden.syr.vec.sh";
        };
      };
    });
}
