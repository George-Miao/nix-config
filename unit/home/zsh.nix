{...}: {
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
      "rb" = "(cd $HOME/.nix-config && git add --all && nix run '.#activate')";
      "sync_conf" = "(cd $HOME/.nix-config && git add --all && git commit --all --message Update && git pull &&  git push)";
      "src" = "rb";
      "code-insiders" = "code-insiders --enable-wayland-ime --";
      "codei" = "code-insiders";
      "ls" = "lsd";
      "la" = "ll -a";
      "tree" = "ls --tree";
      "print" = "lpr";
      ":wq" = "exit";
    };

    antidote = {
      enable = true;
      plugins = ["chisui/zsh-nix-shell"];
    };

    onMyZsh = {
      enable = true;
      theme = "agnoster";
      plugins = ["git" "sudo"];
    };

    initExtra = ''
      function run() { nix run nixpkgs#$1 -- ''${*[@]:2} }
    '';
  };
}
