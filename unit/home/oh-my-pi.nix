{ lib, pkgs, ... }:
let
  plugins = [
    "pi-web-access"
    "@juicesharp/rpiv-ask-user-question"
    "pi-condense"
    "@czottmann/pi-automode"
  ];
  configFile = (pkgs.formats.yaml { }).generate "omp-config.yml" {
    # pi-automode owns approval decisions. Keeping OMP's native prompt enabled
    # would ask again after the classifier already approved an action.
    tools.approvalMode = "yolo";
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

  home.file.".omp/agent/config.yml".source = configFile;

  # pi-automode deliberately reads Pi-owned configuration even under OMP.
  # Per-project, uncommitted overrides belong in .pi/automode.local.json.
  home.file.".pi/agent/automode.json".source = automodeConfig;

  home.activation.installOmpPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${lib.concatMapStringsSep "\n" (plugin: ''
      pluginManifest="$HOME/.omp/plugins/node_modules/${plugin}/package.json"
      if [ ! -e "$pluginManifest" ]; then
        $DRY_RUN_CMD ${omp}/bin/omp plugin install ${lib.escapeShellArg plugin}
      fi
    '') plugins}
  '';
}
