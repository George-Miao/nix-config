{ ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    antidote = {
      enable = true;
      plugins = [
        "chisui/zsh-nix-shell"
      ];
    };

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
        "sudo"
      ];
    };
  };
}
