{
  self,
  consts,
  config,
  lib,
  ...
}: let
  users = lib.attrsets.genAttrs ["root" config.user] (user: {
    openssh.authorizedKeys.keys = [
      consts.ssh
    ];
  });
in {
  flake.nixosModules.server = {
    imports = [
      ../shared
      ../shared/nixos.nix
      self.nixosModules.home-manager
    ];

    services.openssh.enable = true;

    users.users = users;

    home-manager.users.${config.user} = {
      imports = [self.homeModules.server];
    };
  };
}
