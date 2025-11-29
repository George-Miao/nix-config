{
  description = "My Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flakes = {
      url = "github:George-Miao/flakes";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.utils.follows = "flake-utils";
    };

    forrit = {
      url = "github:George-Miao/forrit";
      inputs = {
        crane.follows = "crane";
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        rust-overlay.follows = "rust-overlay";
      };
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixlib.follows = "community-lib";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs = {
        crane.follows = "crane";
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        flake-compat.follows = "flake-compat";
        rust-overlay.follows = "rust-overlay";
      };
    };

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "community-lib";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    crane.url = "github:ipetkov/crane";
    community-lib.url = "github:nix-community/nixpkgs.lib";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
  };

  outputs =
    inputs@{
      self,
      flakes,
      nixpkgs,
      flake-parts,
      nix-darwin,
      deploy-rs,
      home-manager,
      nixos-generators,
      lanzaboote,
      vscode-server,
      nix-index-database,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      with builtins;
      let
        secrets = import secrets/secrets.nix;
        consts = {
          gpg = readFile "${self}/static/gpg.pub";
          ssh = readFile "${self}/static/ssh.pub";
        };
        unit = import ./unit;
        specialArgs = {
          inherit
            unit
            inputs
            consts
            secrets
            ;
        };
        modules = [
          (
            { pkgs, config, ... }:
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;

                users.pop.imports = [
                  nix-index-database.homeModules.nix-index
                ];
              };

              nixpkgs.overlays = [ flakes.overlays.default ];
            }
          )
        ];
        mkDarwinSystem =
          machine:
          moduleWithSystem {
            specialArgs = specialArgs;
            modules = modules ++ [
              machine
              home-manager.darwinModules.home-manager

              ./system/darwin
            ];
          };
        mkLinuxDesktop =
          machine:
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = specialArgs;
            modules = modules ++ [
              machine
              home-manager.nixosModules.home-manager
              vscode-server.nixosModules.default
              lanzaboote.nixosModules.lanzaboote

              ./system/nixos-desktop
            ];
          };
        mkLinuxServer =
          machine:
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = specialArgs;
            modules = modules ++ [
              machine
              home-manager.nixosModules.home-manager
              vscode-server.nixosModules.default

              ./system/nixos-server
            ];
          };
        mkLinuxService =
          service:
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = specialArgs;
            modules = modules ++ [
              home-mnanager.nixosModules.home-manager
              ({ imports = [ (service unit) ]; })

              machine/ProxmoxLXC
            ];
          };
        mkLinuxDeploy =
          node: hostname:
          let
            pkgs = import nixpkgs {
              system = "x86_64-linux";
              overlays = [
                deploy-rs.overlays.default
                (self: super: {
                  deploy-rs = {
                    inherit (pkgs) deploy-rs;
                    lib = deploy-rs.lib;
                  };
                })
              ];
            };
          in
          {
            inherit hostname;
            profiles.system = {
              user = "root";
              sshUser = "root";
              sshOpts = [
                "-p"
                "2222"
              ];
              path = pkgs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."${node}";
            };
          };
      in
      {
        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];

        perSystem =
          {
            pkgs,
            system,
            ...
          }:
          {
            formatter = pkgs.nixfmt-tree;
            packages = rec {
              default = activate;

              activate =
                let
                  activateCmd =
                    if pkgs.stdenv.hostPlatform.isLinux then
                      "nixos-rebuild switch --flake ."
                    else if pkgs.stdenv.hostPlatform.isDarwin then
                      "darwin-rebuild switch --flake ."
                    else
                      throw "Unsupported system: ${system}";
                in
                pkgs.writeShellScriptBin "activate" ''
                  cd $HOME/.nix-config
                  git add --all
                  sudo ${activateCmd}
                '';

              proxmox-lxc = nixos-generators.nixosGenerate {
                inherit system;
                format = "proxmox-lxc";
                specialArgs = specialArgs // {
                  inherit pkgs;
                };
                modules = [
                  { nix.registry.nixpkgs.flake = nixpkgs; }
                  machine/ProxmoxLXC
                ];
              };
            };
          };

        flake = {
          checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

          nixosConfigurations = {
            Atlas = mkLinuxDesktop machine/Atlas;
            Everest = mkLinuxDesktop machine/Everest;
            Colden = mkLinuxServer machine/Colden;
            LUX = mkLinuxServer machine/LUX;
            LAX = mkLinuxServer machine/LAX;
            EWR = mkLinuxServer machine/EWR;
            HEL = mkLinuxServer machine/HEL;
            HND = mkLinuxServer machine/HND;
            YUL = mkLinuxServer machine/YUL;
            Forrit = mkLinuxService (unit: (unit.sys.forrit secrets.syr.forrit));
          };

          darwinConfigurations = {
            Fuji = mkDarwinSystem machine/Fuji;
            Marcy = mkDarwinSystem machine/Marcy;
          };

          deploy.nodes = {
            Forrit = mkLinuxDeploy "Forrit" "forrit.syr.vec.sh";
            Colden = mkLinuxDeploy "Colden" "colden.syr.vec.sh";
            LUX = mkLinuxDeploy "LUX" "lux.vec.sh";
            EWR = mkLinuxDeploy "EWR" "ewr.vec.sh";
            HEL = mkLinuxDeploy "HEL" "hel.vec.sh";
            LAX = mkLinuxDeploy "LAX" "lax.vec.sh";
            HND = mkLinuxDeploy "HND" "hnd.vec.sh";
            YUL = mkLinuxDeploy "YUL" "yul.vec.sh";
          };
        };
      }
    );
}
