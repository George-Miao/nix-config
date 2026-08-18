{
  config,
  lib,
  pkgs,
  ...
}:
let
  plugins = [
    # 0.18.0+ imports resizeImage, which OMP's legacy coding-agent shim does not expose.
    {
      name = "pi-web-access";
      version = "0.17.1";
    }
    { name = "@juicesharp/rpiv-ask-user-question"; }
    # 2.4.1+ requires the upstream Pi ModelRegistry.getProviderAuth API, which OMP does not expose.
    {
      name = "pi-condense";
      version = "2.4.0";
    }
    { name = "@czottmann/pi-automode"; }
  ];
  configFile = (pkgs.formats.yaml { }).generate "omp-config.yml" {
    modelRoles.default = "openai-codex/gpt-5.6-sol";
    setupVersion = 1;
    symbolPreset = "nerd";
    theme.light = "light";
    # pi-automode owns approval decisions. Keeping OMP's native prompt enabled
    # would ask again after the classifier already approved an action.
    tools.approvalMode = "yolo";
  };
  syncConfig = pkgs.writeShellApplication {
    name = "sync-omp-config";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.yq-go
    ];
    text = ''
      configPath="''${1:?usage: sync-omp-config CONFIG_PATH}"
      configDir="$(dirname "$configPath")"

      mkdir -p "$configDir"
      tempPath="$(mktemp "$configDir/.config.yml.XXXXXX")"
      trap 'rm -f -- "$tempPath"' EXIT

      if [[ -e "$configPath" || -L "$configPath" ]]; then
        yq eval-all --prettyPrint \
          ". as \$item ireduce ({}; . * \$item)" \
          ${configFile} "$configPath" > "$tempPath"
      else
        cp ${configFile} "$tempPath"
      fi

      chmod 0644 "$tempPath"
      mv -f "$tempPath" "$configPath"
      trap - EXIT
    '';
  };
  settingsFile = (pkgs.formats.json { }).generate "omp-settings.json" {
    contextPrune.summarizerModel = "openai-codex/gpt-5.6-luna";
  };
  syncSettings = pkgs.writeShellApplication {
    name = "sync-omp-settings";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.jq
    ];
    text = ''
      settingsPath="''${1:?usage: sync-omp-settings SETTINGS_PATH}"
      settingsDir="$(dirname "$settingsPath")"

      mkdir -p "$settingsDir"
      tempPath="$(mktemp "$settingsDir/.settings.json.XXXXXX")"
      trap 'rm -f -- "$tempPath"' EXIT

      if [[ -e "$settingsPath" || -L "$settingsPath" ]]; then
        jq --slurp '.[0] * .[1]' "$settingsPath" ${settingsFile} > "$tempPath"
      else
        cp ${settingsFile} "$tempPath"
      fi

      chmod 0644 "$tempPath"
      mv -f "$tempPath" "$settingsPath"
      trap - EXIT
    '';
  };
  automodeConfig = (pkgs.formats.json { }).generate "omp-automode.json" {
    autoMode = {
      enabled = true;
      classifierModel = "openai-codex/gpt-5.5";
      classifierReasoningLevel = "low";
      allowInsideWorkingDirectory = true;
      deniedPaths = [
        "~/.aws/*"
        "~/.codex/auth.json"
        "~/.config/gh/hosts.yml"
        "~/.gnupg/*"
        "~/.nix-config/secrets/*"
        "~/.omp/agent/agent.db*"
        "~/.ssh/*"
      ];
      environment = [ "$defaults" ];
      allow = [ "$defaults" ];
      protectedPaths = [ "$defaults" ];
      soft_deny = [ "$defaults" ];
      hard_deny = [ "$defaults" ];
    };
  };
  omp = pkgs.writeShellApplication {
    name = "omp";
    runtimeInputs = [ pkgs.bun ];
    text = ''
      case "''${1-}" in
        plugin | completions | --help | -h | --version | -V)
          exec ${pkgs.oh-my-pi}/bin/omp "$@"
          ;;
      esac

      automodePath="$HOME/.omp/plugins/node_modules/@czottmann/pi-automode/extensions/auto-mode.ts"
      if [[ ! -f "$automodePath" ]]; then
        echo "omp: refusing to start without pi-automode; run rb to install it" >&2
        exit 1
      fi

      if ! ${pkgs.oh-my-pi}/bin/omp plugin doctor --json >/dev/null; then
        echo "omp: refusing to start because an OMP plugin failed validation" >&2
        echo "omp: run 'omp plugin doctor' for details" >&2
        exit 1
      fi

      exec ${pkgs.oh-my-pi}/bin/omp "$@"
    '';
  };
in
{
  home.packages = [ omp ];

  # OMP writes runtime settings to this file. Keep it outside Home Manager's
  # read-only store links, and merge new Nix defaults underneath runtime edits.
  home.file.".omp/agent/config.yml".enable = false;

  home.activation.syncOmpConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${syncConfig}/bin/sync-omp-config "$HOME/.omp/agent/config.yml"
  '';

  # pi-condense shares OMP's writable settings file. Enforce only the selected
  # summarizer while preserving every other runtime-managed setting.
  home.file.".omp/agent/settings.json".enable = false;
  home.file.".omp/agent/APPEND_SYSTEM.md".text = config.agent.context;

  home.activation.syncOmpSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${syncSettings}/bin/sync-omp-settings "$HOME/.omp/agent/settings.json"
  '';

  # pi-automode deliberately reads Pi-owned configuration even under OMP.
  # Per-project, uncommitted overrides belong in .pi/automode.local.json.
  home.file.".pi/agent/automode.json".source = automodeConfig;

  home.activation.installOmpPlugins = lib.hm.dag.entryAfter [ "syncOmpConfig" ] ''
    ${lib.concatMapStringsSep "\n" (
      plugin:
      let
        package = plugin.name + lib.optionalString (plugin ? version) "@${plugin.version}";
        needsInstall =
          if plugin ? version then
            ''[ ! -e "$pluginManifest" ] || [ "$(${lib.getExe pkgs.jq} -r '.version // empty' "$pluginManifest" 2>/dev/null || true)" != ${lib.escapeShellArg plugin.version} ]''
          else
            ''[ ! -e "$pluginManifest" ]'';
      in
      ''
        pluginManifest="$HOME/.omp/plugins/node_modules/${plugin.name}/package.json"
        if ${needsInstall}; then
          $DRY_RUN_CMD ${omp}/bin/omp plugin install ${lib.escapeShellArg package}
        fi
      ''
    ) plugins}
  '';
}
