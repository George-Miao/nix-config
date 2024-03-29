{
  description = "My Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Rust
    rust-overlay.url = "github:oxalica/rust-overlay";

    # Flake Parts
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";

    # Hyperland
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    nixos-flake,
    rust-overlay,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];
      imports = [
        nixos-flake.flakeModule
        ./config.nix
        ./unit
        ./system/darwin
        ./system/nixos-desktop
        ./system/nixos-server
      ];

      flake = {
        secrets = with builtins;
          fromJSON (readFile "${self}/secrets/secrets.json");
        nixosConfigurations = {
          atlas = self.nixos-flake.lib.mkLinuxSystem machine/atlas;
        };
      };
    };
}
