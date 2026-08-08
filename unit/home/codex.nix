{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.codex = {
    enable = true;
    settings = {
      approvals_reviewer = "auto_review";
      tui = {
        theme = "inspired-github";
        status_line = [
          "model-with-reasoning"
          "current-dir"
          "git-branch"
          "pull-request-number"
          "branch-changes"
          "run-state"
          "context-used"
          "weekly-limit"
          "codex-version"
          "used-tokens"
          "fast-mode"
          "task-progress"
        ];
        status_line_use_colors = true;
      };
    };
  };

  # Codex persists runtime state (e.g. trusted-directory decisions) by
  # writing straight into config.toml. Home Manager normally manages that
  # file as a read-only symlink into the Nix store, which silently breaks
  # those writes. Stop managing it and seed it once instead, so Codex owns
  # the file (and can freely add trusted directories) from then on.
  home.file.".codex/config.toml".enable = false;

  home.activation.seedCodexConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    codexConfig="$HOME/.codex/config.toml"
    if [ ! -e "$codexConfig" ]; then
      install -Dm644 ${
        (pkgs.formats.toml { }).generate "codex-config" config.programs.codex.settings
      } "$codexConfig"
    fi
  '';
}
