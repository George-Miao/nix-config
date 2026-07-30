{ ... }:
{
  programs.lsd = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      sorting = {
        column = "time";
        reverse = true;
      };
    };
  };
}
