{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
  };

  programs.zsh.shellAliases."zed" = "${pkgs.zed-editor}/bin/zeditor";
}
