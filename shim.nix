inputs @ {
  self,
  nixpkgs,
  deploy-rs,
  flake-parts,
  nix-darwin,
  ...
}: callback:
flake-parts.lib.mkFlake {inherit inputs;} (args:
    with builtins; let
      secrets = fromJSON (readFile "${self}/secrets/secrets.json");
      consts = {
        gpg = readFile "${self}/static/gpg.pub";
        ssh = readFile "${self}/static/ssh.pub";
      };
      tools = {
        inspect = a: b: builtins.trace (builtins.attrNames a) b;
        generate = pkgs: (import "${self}/_sources/generated.nix") {inherit (pkgs) fetchgit fetchurl fetchFromGitHub dockerTools;};
        bind = path: args: input: (import path) args input;
      };
      extra = {inherit (args) flake-parts-lib;} // {inherit tools consts secrets;};
      shim = {
        mkLinuxSystem = mod:
          nixpkgs.lib.nixosSystem {
            specialArgs = self.nixos-flake.lib.specialArgsFor.nixos // extra;
            modules = [self.nixosModules.nixosFlake mod];
          };
        mkMacosSystem = mod:
          nix-darwin.lib.darwinSystem {
            specialArgs = self.nixos-flake.lib.specialArgsFor.nixos // extra;
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
      };
    in
      callback shim)
