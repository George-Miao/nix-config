{
  self,
  pkgs,
  specialArgs,
  ...
}: {
  flake.nixosModules.minimum = {
    imports = [self.nixosModules.home-manager];

    nix.settings.experimental-features = ["nix-command" "flakes" "repl-flake"];
    nixpkgs.config.allowUnfree = true;

    services.openssh.enable = true;

    users.users.root = {
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        self.extra.consts.ssh
      ];
    };

    home-manager = {
      extraSpecialArgs = {
        inherit (specialArgs) consts tools secrets;
      };
      users.root.imports = [self.homeModules.bare];
    };
  };
}
