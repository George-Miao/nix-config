{ lib, ... }:
{
  programs.git = {
    enable = true;

    signing = {
      key = "DB4536E20EB42CE6";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "George Miao";
        email = "gm@miao.dev";
      };

      init.defaultBranch = "main";
      tag.gpgSign = true;
      push.autoSetupRemote = true;
      pull.rebase = true;
      rerere.enabled = true;

      credential.helper = lib.mkBefore [ "cache --timeout=7200" ];
      "credential \"https://git.miao.dev\"" = {
        oauthClientId = "a4792ccc-144e-407e-86c9-5e7d8d9c3269";
        oauthAuthURL = "/login/oauth/authorize";
        oauthTokenURL = "/login/oauth/access_token";
      };
    };
  };

  programs.difftastic = {
    enable = true;
    git = {
      enable = true;
      diffToolMode = true;
    };
  };

  programs.git-credential-oauth.enable = true;
}
