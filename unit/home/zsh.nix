{ ... }:
{
  programs.zoxide = {
    enable = true;
    options = [
      "--cmd"
      "j"
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      "c" = "clear";
      "sys" = "sudo systemctl";
      "sysu" = "systemctl --user";
      "rb" = "(cd $HOME/.nix-config && git add --all && sudo nix run '.#activate')";
      "sync_conf" =
        "(cd $HOME/.nix-config && git add --all && git commit --all --message Update && git pull && git push)";
      "sync_typst" =
        "(j common && git add --all && git commit --all --message Update && git pull && git push)";
      "src" = "rb";
      "tree" = "ls --tree";
      "print" = "lpr";
      ":wq" = "exit";
      "bw" = "rbw";
      "note" = "fd Note.typ -x typst c {}";
      "codei" = "code-insiders";
    };

    antidote = {
      enable = true;
      plugins = [ "chisui/zsh-nix-shell" ];
    };

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
        "sudo"
      ];
    };

    initContent = ''
      autoload -Uz compinit
      compinit

      function run() { nix run nixpkgs#$1 -- ''${*[@]:2} }

      export PATH="$HOME/.npm-packages/bin:$PATH"
    '';
  };
}
