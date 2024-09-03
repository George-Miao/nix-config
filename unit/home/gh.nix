{flake, ...}: {
  programs.gh = {
    enable = true;
  };

  xdg.configFile.gh-hosts = let
    github = flake.self.secrets.github;
  in {
    recursive = true;
    target = "gh/hosts.yml";
    text = builtins.toJSON {
      "github.com" = {
        users = {
          "${github.user}" = {
            oauth_token = github.oauth_token;
          };
        };
        git_protocol = "https";
        oauth_token = github.oauth_token;
        user = github.user;
      };
    };
  };
}
