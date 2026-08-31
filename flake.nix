{
  description = "My Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "community-lib";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-skills = {
      url = "github:sudosubin/nix-skills";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    crane.url = "github:ipetkov/crane";
    community-lib.url = "github:nix-community/nixpkgs.lib";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs =
    inputs@{
      self,
      flakes,
      nixpkgs,
      deploy-rs,
      nix-darwin,
      nix-skills,
      flake-parts,
      home-manager,
      nixos-generators,
      vscode-server,
      nix-index-database,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      with builtins;
      let
        # secretsFile = getEnv "SECRETS_FILE";
        # secrets = if secretsFile == "" then throw "Cannot load secret" else fromJSON (readFile secretsFile);
        secrets = import ./secrets/secrets.nix;
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
        modules = username: [
          (
            { pkgs, config, ... }:
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                backupFileExtension = "bkup";

                users.${username}.imports = [
                  nix-index-database.homeModules.nix-index
                ];
              };

              nixpkgs.overlays = [
                flakes.overlays.default
                nix-skills.overlays.default
              ];
            }
          )
        ];
        mkDarwinSystem =
          machine: username:
          nix-darwin.lib.darwinSystem {
            specialArgs = specialArgs;
            modules = (modules username) ++ [
              machine
              home-manager.darwinModules.home-manager

              (import ./system/darwin username)
            ];
          };
        mkLinuxDesktop =
          machine:
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = specialArgs;
            modules = (modules "pop") ++ [
              machine
              home-manager.nixosModules.home-manager
              vscode-server.nixosModules.default

              ./system/nixos-desktop
            ];
          };
        mkLinuxServer =
          machine:
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = specialArgs;
            modules = (modules "pop") ++ [
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
            devShells.default = pkgs.mkShell {
              packages = with pkgs; [
                infisical
                jq
                uv
              ];
            };
            packages = rec {
              default = activate;

              activate = import ./lib/mk-apply.nix {
                inherit pkgs;
                name = "activate";
                rebuildCommand =
                  if pkgs.stdenv.hostPlatform.isLinux then
                    "nixos-rebuild switch"
                  else if pkgs.stdenv.hostPlatform.isDarwin then
                    "darwin-rebuild switch"
                  else
                    throw "Unsupported system: ${system}";
              };

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
            Akan = mkLinuxDesktop machine/Akan;
            Everest = mkLinuxDesktop machine/Everest;
            Colden = mkLinuxServer machine/Colden;
            LUX = mkLinuxServer machine/LUX;
            HEL = mkLinuxServer machine/HEL;
            YUL = mkLinuxServer machine/YUL;
            KIX = mkLinuxServer machine/KIX;
            Forrit = mkLinuxService (unit: (unit.sys.forrit secrets.syr.forrit));
          };

          darwinConfigurations = {
            Fuji = mkDarwinSystem machine/Fuji "pop";
            FWLT9207DY = mkDarwinSystem machine/Kong "george.miao";
            Kong = mkDarwinSystem machine/Kong "george.miao";
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
