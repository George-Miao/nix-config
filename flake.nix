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
    nixpkgs,
    flake-parts,
    nix-darwin,
    nixos-flake,
    deploy-rs,
    ...
  }:
    with builtins; let
      secrets = fromJSON (readFile "${self}/secrets/secrets.json");
      consts = {
        gpg = readFile "${self}/static/gpg.pub";
        ssh = readFile "${self}/static/ssh.pub";
      };
      tools = {
        inspect = a: b: builtins.trace (builtins.attrNames a) b;
        generate = pkgs: (import "${self}/_sources/generated.nix") {inherit (pkgs) fetchgit fetchurl fetchFromGitHub dockerTools;};
      };
    in
      flake-parts.lib.mkFlake {inherit inputs;} (args: let
        extra = {
          inherit tools consts secrets;
          inherit (args) flake-parts-lib;
        };
        mkLinuxSystem = mod:
          nixpkgs.lib.nixosSystem {
            specialArgs = extra // self.nixos-flake.lib.specialArgsFor.nixos;
            modules = [self.nixosModules.nixosFlake mod];
          };
        mkMacosSystem = mod:
          nix-darwin.lib.darwinSystem {
            specialArgs = self.nixos-flake.lib.specialArgsFor.darwin // extra;
            modules = [self.darwinModules_.nixosFlake mod];
          };
        mkLinuxDeploy = node: hostname: {
          inherit hostname;
          profiles.system = {
            user = "root";
            sshUser = "root";
            fastConnection = true;
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
            Atlas = mkLinuxSystem machine/Atlas;
            Everest = mkLinuxSystem machine/Everest;
            Colden = mkLinuxSystem machine/Colden;
            LUX = mkLinuxSystem machine/LUX;
          };
          darwinConfigurations = {
            Fuji = mkMacosSystem machine/Fuji;
          };
          deploy.nodes = {
            Colden = mkLinuxDeploy "Colden" "colden.syr.vec.sh";
            LUX = mkLinuxDeploy "LUX" "ssh.lux.vec.sh";
          };
        };
      });
}
