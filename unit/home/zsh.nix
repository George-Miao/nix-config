{flake, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      "c" = "clear";
      "sys" = "sudo systemctl";
      "rebuild" = "sudo nixos-rebuild switch --flake /home/${flake.config.user}/.nix-config";
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
