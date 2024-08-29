{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    ueberzugpp
  ];
}
