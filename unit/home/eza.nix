{ ... }:
{
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    extraOptions = [
      "--sort=date"
      "--reverse"
    ];
  };
}
