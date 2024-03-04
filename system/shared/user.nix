{
  flake,
  pkgs,
  ...
}: {
  programs.zsh.enable = true;

  users.users.${flake.config.user} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };
}
