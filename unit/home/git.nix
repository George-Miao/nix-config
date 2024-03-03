{ flake, ... }: {
  programs.git = {
    enable = true;

    userName = "George Miao";
    userEmail = "gm@miao.dev";

    difftastic = {
      enable = true;
    };

    signing = {
      key = null;
      signByDefault = true;
    };

    extraConfig = {
      init.defaultBranch = "main";
      tag.gpgSign = true;
      url = {
        "https://oauth2:${flake.inputs.self.secrets.github.oauth_token}@github.com" = {
          insteadOf = "https://github.com";
        };
      };
    };
  };
}
