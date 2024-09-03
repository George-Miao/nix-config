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
    disko,
    deploy-rs,
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
        checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
        secrets = fromJSON (readFile "${self}/secrets/secrets.json");
        tools = {
          inspect = a: b: builtins.trace (builtins.attrNames o) b;
          generate = pkgs: (import _sources/generated.nix) {inherit (pkgs) fetchgit fetchurl fetchFromGitHub dockerTools;};
          mkLinuxDeploy = node: {
            hostname = "colden.syr.vec.sh";
            profiles.system = {
              user = "root";
              sshUser = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."${node}";
            };
          };
        };
        consts = {
          gpg = readFile "${self}/static/gpg.pub";
          ssh = readFile "${self}/static/ssh.pub";
        };
        nixosConfigurations = {
          Atlas = self.nixos-flake.lib.mkLinuxSystem machine/Atlas;
          Everest = self.nixos-flake.lib.mkLinuxSystem machine/Everest;
          Colden = self.nixos-flake.lib.mkLinuxSystem machine/Colden;
        };
        darwinConfigurations = {
          Fuji = self.nixos-flake.lib.mkMacosSystem machine/Fuji;
        };
        deploy.nodes = {
          Colden = self.tools.mkLinuxDeploy "Colden";
        };
      };
    };
}
