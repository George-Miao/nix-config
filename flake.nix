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

    # Flake Parts
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    nixos-flake,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
      imports = [
        nixos-flake.flakeModule
        ./config.nix
        ./unit
        ./system/darwin
        ./system/nixos-desktop
        ./system/nixos-server
      ];

      flake = with builtins; {
        secrets = fromJSON (readFile "${self}/secrets/secrets.json");
        tools = {
          generate = pkgs: (import _sources/generated.nix) {inherit (pkgs) fetchgit fetchurl fetchFromGitHub dockerTools;};
        };
        consts = {
          gpg = readFile "${self}/static/pub.gpg";
        };
        nixosConfigurations = {
          Atlas = self.nixos-flake.lib.mkLinuxSystem machine/Atlas;
          Everest = self.nixos-flake.lib.mkLinuxSystem machine/Everest;
        };
        darwinConfigurations = {
          Fuji = self.nixos-flake.lib.mkMacosSystem machine/Fuji;
        };
      };
    };
}
