{
  description = "My Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

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

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
  };

  outputs = inputs @ {
    self,
    nur,
    nixpkgs,
    flake-parts,
    nix-darwin,
    nixos-flake,
    deploy-rs,
    nixos-generators,
    ...
  }:
    with builtins; let
      secrets = import secrets/secrets.nix;
      consts = {
        gpg = readFile "${self}/static/gpg.pub";
        ssh = readFile "${self}/static/ssh.pub";
      };
      tools = {
        toArray = a:
          if isList a
          then a
          else [a];
        inspect = a: b: builtins.trace (builtins.attrNames a) b;
        isMac = pkgs: with builtins; isList (match ".*darwin" pkgs.system);
        generate = pkgs: (import "${self}/_sources/generated.nix") {inherit (pkgs) fetchgit fetchurl fetchFromGitHub dockerTools;};
      };
    in
      flake-parts.lib.mkFlake {inherit inputs;} ({flake-parts-lib, ...}: let
        extra = {inherit tools secrets flake-parts-lib;};
        deployPkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [
            deploy-rs.overlay # or deploy-rs.overlays.default
            (self: super: {
              deploy-rs = {
                inherit (pkgs) deploy-rs;
                lib = deploy-rs.lib;
              };
            })
          ];
        };
        mkMacosSystem = machine:
          nix-darwin.lib.darwinSystem {
            specialArgs =
              self.nixos-flake.lib.specialArgsFor.darwin
              // extra
              // {consts = consts // {os = "darwin";};};
            modules = [self.darwinModules_.nixosFlake] ++ (tools.toArray machine);
          };
        mkLinuxSystem = machine:
          nixpkgs.lib.nixosSystem {
            specialArgs =
              self.nixos-flake.lib.specialArgsFor.nixos
              // extra
              // {consts = consts // {os = "linux";};};
            modules = [self.nixosModules.nixosFlake nur.modules.nixos.default] ++ (tools.toArray machine);
          };
        mkLinuxService = service:
          nixpkgs.lib.nixosSystem {
            specialArgs =
              self.nixos-flake.lib.specialArgsFor.nixos
              // extra
              // {consts = consts // {os = "linux";};};
            modules = [
              self.nixosModules.nixosFlake
              machine/ProxmoxLXC
              ({flake, ...}: {imports = tools.toArray (service flake.self.unit);})
            ];
          };
        mkLinuxDeploy = node: hostname: {
          inherit hostname;
          profiles.system = {
            user = "root";
            sshUser = "root";
            sshOpts = ["-p" "2222"];
            path = deployPkgs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."${node}";
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

        perSystem = {
          pkgs,
          system,
          ...
        }: {
          packages = {
            proxmox-lxc = nixos-generators.nixosGenerate {
              inherit system;
              specialArgs = {inherit pkgs;} // self.nixos-flake.lib.specialArgsFor.nixos // extra;
              modules = [
                self.nixosModules.nixosFlake
                ({...}: {nix.registry.nixpkgs.flake = nixpkgs;})
                machine/ProxmoxLXC
              ];
              format = "proxmox-lxc";
            };
          };
        };

        flake = {
          inherit extra;

          checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
          nixosConfigurations = {
            Atlas = mkLinuxSystem machine/Atlas;
            Everest = mkLinuxSystem machine/Everest;
            Colden = mkLinuxSystem machine/Colden;
            LUX = mkLinuxSystem machine/LUX;
            LAX = mkLinuxSystem machine/LAX;
            LAX-2 = mkLinuxSystem machine/LAX-2;
            EWR = mkLinuxSystem machine/EWR;
            HEL = mkLinuxSystem machine/HEL;
            HND = mkLinuxSystem machine/HND;
            YUL = mkLinuxSystem machine/YUL;
            Forrit = mkLinuxService (unit: (unit.sys.forrit secrets.syr.forrit));
          };
          darwinConfigurations = {
            Fuji = mkMacosSystem machine/Fuji;
            Marcy = mkMacosSystem machine/Marcy;
          };

          deploy.nodes = {
            Forrit = mkLinuxDeploy "Forrit" "forrit.syr.vec.sh";
            Colden = mkLinuxDeploy "Colden" "colden.syr.vec.sh";
            LUX = mkLinuxDeploy "LUX" "lux.vec.sh";
            EWR = mkLinuxDeploy "EWR" "ewr.vec.sh";
            HEL = mkLinuxDeploy "HEL" "hel.vec.sh";
            LAX = mkLinuxDeploy "LAX" "lax.vec.sh";
            LAX-2 = mkLinuxDeploy "LAX-2" "lax-2.vec.sh";
            HND = mkLinuxDeploy "HND" "hnd.vec.sh";
            YUL = mkLinuxDeploy "YUL" "yul.vec.sh";
          };
        };
      });
}
