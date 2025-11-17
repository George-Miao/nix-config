{
  flake,
  pkgs,
  ...
}:
{
  programs.zsh.enable = true;

  users.users.${flake.config.user} = {
    shell = pkgs.zsh;
  };
}
