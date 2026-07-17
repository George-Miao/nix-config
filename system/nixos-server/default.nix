{
  unit,
  ...
}:
{
  imports = [
    ../shared
    ../shared/nixos.nix
    unit.sys.sshd
  ];

  home-manager.users.pop = {
    imports = [ unit.preset.server ];
  };
}
