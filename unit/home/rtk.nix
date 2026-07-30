{ pkgs, ... }:

let
  version = "0.43.0";
  source = pkgs.fetchFromGitHub {
    owner = "rtk-ai";
    repo = "rtk";
    tag = "v${version}";
    hash = "sha256-n5bkPPsrdM4fE5ltocTjlq+JwRgp39yib6S79fci4m4=";
  };
  filters = pkgs.runCommand "rtk-filters.toml" { } ''
    sed -n '/^const FILTERS_GLOBAL_TEMPLATE: &str = r#"/,/^"#;$/p' \
      ${source}/src/hooks/init.rs \
      | sed '1s/.*r#"//' \
      | sed '$s/"#;//' \
      > "$out"
  '';
in
{
  home.packages = [ pkgs.rtk ];

  programs.claude-code = {
    context = "@RTK.md";
    settings.hooks.PreToolUse = [
      {
        matcher = "Bash";
        hooks = [
          {
            type = "command";
            command = "rtk hook claude";
          }
        ];
      }
    ];
  };

  programs.codex.context = "@RTK.md";

  home.file = {
    ".claude/RTK.md".source = source + "/hooks/claude/rtk-awareness.md";
    ".codex/RTK.md".source = source + "/hooks/codex/rtk-awareness.md";
    "Library/Application Support/rtk/filters.toml".source = filters;
  };

  xdg.configFile."opencode/plugins/rtk.ts".source = source + "/hooks/opencode/rtk.ts";
}
