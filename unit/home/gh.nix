{ ... }: {
  programs.gh = {
    enable = true;
    gitCredentialManager.enable = true;
  };
}
