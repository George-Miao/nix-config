{ ... }: {
  programs.git = {
    enable = true;

    userName = "George Miao";
    userEmail = "gm@miao.dev";

    extraConfig = {
      init.defaultBranch = "main";
    };
    difftastic = {
      enable = true;
    };
    signing = {
      key = null;
      signByDefault = true;
    };
  };
}
