{ pkgs, ... }:
{
  home.packages = [ pkgs.zellij ];

  xdg.configFile.zellij = {
    recursive = true;
    target = "zellij/config.kdl";
    text = import ./zellij.config.nix;
  };
}
