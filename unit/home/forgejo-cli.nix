{
  secrets,
  consts,
  pkgs,
  lib,
  ...
}:
let
  content = builtins.toJSON {
    hosts = {
      "${secrets.forgejo.host}" = {
        type = "Application";
        name = secrets.forgejo.name;
        token = secrets.forgejo.token;
      };
    };
  };
in
{
  home.packages = [ pkgs.forgejo-cli ];

  programs.zsh.shellAliases = {
    "fj" = "${lib.getExe pkgs.forgejo-cli} --host ${secrets.forgejo.host}";
  };

  xdg.configFile.forge-config = {
    recursive = true;
    target = "forgejo/keys.json";
    text = content;
  };

  home.file.forgejo_config = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    recursive = true;
    target = "Library/Application Support/Cyborus.forgejo-cli/keys.json";
    text = content;
  };
}
