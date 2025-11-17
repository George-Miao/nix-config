{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    kubespy
  ];

  programs.zsh.initContent = ''
    source <(${lib.getExe pkgs.kubespy} completion zsh)
  '';
}
