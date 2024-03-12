{flake, ...}: {
  programs.zoxide = {
    enable = true;
    options = ["--cmd" "j"];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      "c" = "clear";
      "sys" = "sudo systemctl";
      "sysu" = "systemctl --user";
      "rb" = "sudo nixos-rebuild switch --flake $HOME/.nix-config";
      "rbf" = "sudo nixos-rebuild switch --fast --flake $HOME/.nix-config";
      "codei" = "code-insiders";
    };

    antidote = {
      enable = true;
      plugins = ["chisui/zsh-nix-shell"];
    };

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = ["git" "sudo"];
    };
  };
}
