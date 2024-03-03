{ pkgs, ... }: {
  programs.zsh.enable = true;

  users.users.pop = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };
}
