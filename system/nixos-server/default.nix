{
  self,
  config,
  lib,
  ...
}: {
  flake.nixosModules.server = {
    imports = [
      ../shared
      ../shared/nixos.nix
      self.nixosModules.home-manager
    ];

    services.openssh.enable = true;

    users.users = lib.attrsets.genAttrs ["root" config.user] (user: {
      openssh.authorizedKeys.keys = [
        self.extra.consts.ssh
      ];
    });

    home-manager.users.${config.user} = {
      imports = [self.homeModules.server];
    };
  };
}
