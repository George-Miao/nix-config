{...}: {
  programs.git = {
    enable = true;

    userName = "George Miao";
    userEmail = "gm@miao.dev";

    difftastic.enable = true;

    signing = {
      key = "FE1B8D89A929808E";
      signByDefault = true;
    };

    extraConfig = {
      init.defaultBranch = "main";
      tag.gpgSign = true;
      push.autoSetupRemote = true;
      pull.rebase = true;
    };
  };

  programs.git-credential-oauth.enable = true;
}
