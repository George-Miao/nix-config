{...}: {
  programs.git = {
    enable = true;

    userName = "George Miao";
    userEmail = "gm@miao.dev";

    difftastic.enable = true;

    signing = {
      key = null;
      signByDefault = true;
    };

    extraConfig = {
      init.defaultBranch = "main";
      tag.gpgSign = true;
      push.autoSetupRemote = true;
      pull.rebase = true;
    };
  };
}
