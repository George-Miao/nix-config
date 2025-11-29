{
  consts,
  lib,
  unit,
  ...
}:
{
  imports = [
    ../shared
    ../shared/nixos.nix
    unit.sys.sshd
  ];

  users.users = lib.attrsets.genAttrs [ "root" "pop" ] (user: {
    openssh.authorizedKeys.keys = [
      consts.ssh
    ];
  });

  home-manager.users.pop = {
    imports = [ unit.preset.server ];
  };
}
