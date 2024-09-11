{
  description = "My Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    forrit = {
      url = "github:George-Miao/forrit";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    nix-darwin,
    nixos-flake,
    deploy-rs,
    ...
  }:
    with builtins; let
      secrets = import "${self}/secrets/secrets.nix";
      consts = {
        gpg = readFile "${self}/static/gpg.pub";
        ssh = readFile "${self}/static/ssh.pub";
      };
      tools = {
        inspect = a: b: builtins.trace (builtins.attrNames a) b;
        generate = pkgs: (import "${self}/_sources/generated.nix") {inherit (pkgs) fetchgit fetchurl fetchFromGitHub dockerTools;};
      };
    in
      flake-parts.lib.mkFlake {inherit inputs;} ({flake-parts-lib, ...}: let
        extra = {inherit tools consts secrets flake-parts-lib;};
        mkLinuxSystem = machine:
          nixpkgs.lib.nixosSystem {
            specialArgs = self.nixos-flake.lib.specialArgsFor.nixos // extra;
            modules = [self.nixosModules.nixosFlake machine];
          };
        mkMacosSystem = machine:
          nix-darwin.lib.darwinSystem {
            specialArgs = self.nixos-flake.lib.specialArgsFor.darwin // extra;
            modules = [self.darwinModules_.nixosFlake machine];
          };
        mkLinuxDeploy = node: hostname: {
          inherit hostname;
          profiles.system = {
            user = "root";
            sshUser = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."${node}";
          };
        };
      in {
        systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
        imports = [
          nixos-flake.flakeModule
          ./config.nix
          ./unit
          ./system/darwin
          ./system/nixos-desktop
          ./system/nixos-server
        ];

        flake = {
          inherit extra;
          checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
          nixosConfigurations = {
            Minimum = mkLinuxSystem machine/Minimum;
            Atlas = mkLinuxSystem machine/Atlas;
            Everest = mkLinuxSystem machine/Everest;
            Colden = mkLinuxSystem machine/Colden;
            LUX = mkLinuxSystem machine/LUX;
            LAX = mkLinuxSystem machine/LAX;
            EWR = mkLinuxSystem machine/EWR;
            HEL = mkLinuxSystem machine/HEL;
            HND = mkLinuxSystem machine/HND;
          };
          darwinConfigurations = {
            Fuji = mkMacosSystem machine/Fuji;
          };
          deploy.nodes = {
            Colden = mkLinuxDeploy "Colden" "colden.syr.vec.sh";
            LUX = mkLinuxDeploy "LUX" "lux.vec.sh";
            EWR = mkLinuxDeploy "EWR" "ewr.vec.sh";
            HEL = mkLinuxDeploy "HEL" "hel.vec.sh";
            LAX = mkLinuxDeploy "LAX" "lax.vec.sh";
            HND = mkLinuxDeploy "HND" "hnd.vec.sh";
          };
        };
      });
}
