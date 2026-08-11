{ pkgs, ... }:
let
  fzf = pkgs.fzf.overrideAttrs (old: {
    # ZLE is a read-only Zsh option. fzf snapshots every option and restores
    # the snapshot twice, which makes each interactive shell print an error.
    postPatch = (old.postPatch or "") + ''
      substituteInPlace shell/key-bindings.zsh \
        --replace-fail \
          '__fzf_key_bindings_options="options=(''${(j: :)''${(kv)options[@]}})"' \
          '__fzf_key_bindings_options="options=(''${(j: :)''${(kv)options[@]}})"
      __fzf_key_bindings_options=''${__fzf_key_bindings_options/zle ''${options[zle]}/}'

      substituteInPlace shell/completion.zsh \
        --replace-fail \
          '__fzf_completion_options="options=(''${(j: :)''${(kv)options[@]}})"' \
          '__fzf_completion_options="options=(''${(j: :)''${(kv)options[@]}})"
      __fzf_completion_options=''${__fzf_completion_options/zle ''${options[zle]}/}'
    '';
  });
in
{
  home.shell.enableZshIntegration = true;

  programs.zoxide = {
    enable = true;
    options = [
      "--cmd"
      "j"
    ];
  };

  programs.fzf = {
    enable = true;
    package = fzf;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      "c" = "clear";
      "sys" = "sudo systemctl";
      "sysu" = "systemctl --user";
      "log" = "journalctl -efu";
      "logu" = "journalctl --user -efu";
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
      plugins = [
        "chisui/zsh-nix-shell"
        "Aloxaf/fzf-tab"
        # "zsh-users/zsh-autosuggestions"
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

    initContent = ''
      zstyle ':completion:*:git-checkout:*' sort false
      zstyle ':completion:*:descriptions' format '[%d]'
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
      zstyle ':fzf-tab:*' use-fzf-default-opts yes
      zstyle ':fzf-tab:*' switch-group '<' '>'

      function run() { nix run nixpkgs#$1 -- ''${*[@]:2} }

      export PATH="$HOME/.npm-packages/bin:$PATH"
    '';
  };
}
