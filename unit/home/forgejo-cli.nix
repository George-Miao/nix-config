{
  secrets,
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

  xdg.dataFile."forgejo-cli/keys.json".text = content;
}
