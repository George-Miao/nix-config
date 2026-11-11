{ config, pkgs, ... }:
{
  home.packages = [
    # ccusage 20.0.37 needs zstd for its Rust build.
    (pkgs.ccusage.overrideAttrs (old: {
      buildInputs = old.buildInputs ++ [ pkgs.zstd ];
    }))
  ];

  xdg.configFile."claude/ccusage.json".text = builtins.toJSON {
    "$schema" = "https://ccusage.com/config-schema.json";
    pi.defaults.piPath = "${config.home.homeDirectory}/.omp/agent/sessions";
  };
}
