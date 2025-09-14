{
  self,
  config,
  lib,
  consts,
  ...
}: {
  flake.nixosModules.server = {
    imports = [
      ../shared
      ../shared/nixos.nix
      self.nixosModules.home-manager
      self.unit.sys.sshd
    ];

    users.users = lib.attrsets.genAttrs ["root" config.user] (user: {
      openssh.authorizedKeys.keys = [
        consts.ssh
      ];
    });

    home-manager.users.${config.user} = {
      imports = [self.homeModules.server];
    };
  };
}
