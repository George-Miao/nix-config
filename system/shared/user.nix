{
  pkgs,
  ...
}:
{
  programs.zsh.enable = true;

  users.users.pop = {
    shell = pkgs.zsh;
  };
}
