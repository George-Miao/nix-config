{
  self,
  config,
  ...
}: {
  flake = {
    nixosModules = {
      server = {
        imports = [
          ../shared
          ../shared/nixos.nix
          self.nixosModules.home-manager
        ];

        users.users.${config.user} = {
          openssh.authorizedKeys.keys = [
            self.consts.ssh
          ];
        };

        services.openssh.enable = true;

        home-manager.users.${config.user} = {
          imports = [self.homeModules.server];
        };
      };
    };
  };
}
