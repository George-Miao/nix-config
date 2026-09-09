{ config, pkgs, ... }:
{
  home.packages = [ pkgs.ccusage ];

  xdg.configFile."claude/ccusage.json".text = builtins.toJSON {
    "$schema" = "https://ccusage.com/config-schema.json";
    pi.defaults.piPath = "${config.home.homeDirectory}/.omp/agent/sessions";
  };
}
