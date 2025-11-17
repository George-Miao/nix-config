{ pkgs, ... }:
{
  home.packages = with pkgs; [
    typst
    tinymist
    prettypst
    typstyle
  ];
}
