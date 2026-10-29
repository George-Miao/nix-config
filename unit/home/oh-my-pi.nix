{
  config,
  lib,
  pkgs,
  ...
}:
let
  linuxAudioLibraryPath = lib.optionalString pkgs.stdenv.hostPlatform.isLinux (
    lib.makeLibraryPath [
      pkgs.alsa-lib
      pkgs.libpulseaudio
    ]
  );
  # Use MCP because the native Pi plugin requires a newer Pi API than OMP.
  computerUseLinux = pkgs.stdenv.mkDerivation (
    let
      version = "0.7.23";
      hashes = {
        x86_64-linux = {
          computer-use-linux = "16773c60978f6327f0e586f73e83442014bafe55e713df699a76f5cf80be9cff";
          computer-use-linux-cosmic = "c125c1dd2c7e7afca4c6ea01febdc0d7cf2f52887afd04ec1df6b13e93da3589";
          computer-use-linux-indicator = "a69e6707ad8887b93cc69f1a25cfc3913460fd145470303791b249bcb4e271f1";
        };
        aarch64-linux = {
          computer-use-linux = "87412936360c65d7754415a37e4167b86c467c2f3d6307eb471a39a17731b213";
          computer-use-linux-cosmic = "acc9af8ca71623caf75e53c7a20c1969705d284865e68676a5391994c92fc052";
          computer-use-linux-indicator = "0afc51276b0f8b32eeb0aa8307672f52e4c5573377168d82e3efbe777e0429d3";
        };
      };
      binaries = lib.mapAttrs (
        name: sha256:
        pkgs.fetchurl {
          url = "https://github.com/agent-sh/computer-use-linux/releases/download/v${version}/${name}-${pkgs.stdenv.hostPlatform.parsed.cpu.name}-unknown-linux-gnu";
          inherit sha256;
        }
      ) hashes.${pkgs.stdenv.hostPlatform.system};
    in
    {
      pname = "computer-use-linux";
      inherit version;
      dontUnpack = true;
      nativeBuildInputs = [
        pkgs.autoPatchelfHook
        pkgs.makeWrapper
      ];
      buildInputs = [ pkgs.stdenv.cc.cc.lib ];
      installPhase = ''
        runHook preInstall
        mkdir -p "$out/bin"
        ${lib.concatMapStringsSep "\n" (name: ''install -m755 ${binaries.${name}} "$out/bin/${name}"'') (
          builtins.attrNames binaries
        )}
        wrapProgram "$out/bin/computer-use-linux" \
          --set-default YDOTOOL_SOCKET /run/ydotoold/socket \
          --prefix PATH : ${
            lib.makeBinPath [
              pkgs.wtype
              pkgs.ydotool
              pkgs.xdotool
              pkgs.wmctrl
              pkgs.xprop
              pkgs.glib
            ]
          }
        runHook postInstall
      '';
      meta = {
        description = "Linux desktop control through MCP";
        homepage = "https://github.com/agent-sh/computer-use-linux";
        license = lib.licenses.mit;
        platforms = builtins.attrNames hashes;
        mainProgram = "computer-use-linux";
      };
    }
  );
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
  # OMP stops message_end handlers after 30 seconds. Cancel automatic
  # summarization first so pi-condense restores the pending batches for retry.
  piCondensePatch = pkgs.writeText "pi-condense-message-end-timeout.patch" ''
    --- a/index.ts
    +++ b/index.ts
    @@ -795,8 +795,15 @@
       // before awaiting summarization so print-mode shutdown cannot invalidate the
       // persistence path while the summarizer model is running.
       pi.on("message_end", async (event, ctx) => {
         if (!currentConfig.value.enabled) return;
         if (currentConfig.value.pruneOn !== "agent-message") return;
         if (!isFinalAssistantMessage(event.message)) return;
    -    await flushPending(ctx, { delivery: "session", closingMessage: event.message });
    +    const timeoutController = new AbortController();
    +    const timeoutId = setTimeout(() => timeoutController.abort(), 25_000);
    +    timeoutId.unref?.();
    +    try {
    +      await flushPending(ctx, { delivery: "session", closingMessage: event.message, signal: timeoutController.signal });
    +    } finally {
    +      clearTimeout(timeoutId);
    +    }
       });
  '';
  configFile = (pkgs.formats.yaml { }).generate "omp-config.yml" {
    advisor.enabled = true;
    modelRoles = {
      default = "openai-codex/gpt-6-astra";
      advisor = "openai-codex/gpt-5.6-luna";
    };
    setupVersion = 1;
    symbolPreset = "nerd";
    theme.light = "light";
    # pi-automode owns approval decisions. Keeping OMP's native prompt enabled
    # would ask again after the classifier already approved an action.
    tools.approvalMode = "yolo";
  };
  lspFile = (pkgs.formats.json { }).generate "omp-lsp.json" {
    servers.tinymist = {
      command = lib.getExe pkgs.tinymist;
      args = [ "lsp" ];
      fileTypes = [ ".typ" ];
      languageId = "typst";
      rootMarkers = [
        "typst.toml"
        "*.typ"
      ];
    };
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
    contextPrune = {
      summarizerModel = "openai-codex/gpt-5.6-luna";
      # The automatic flush deadline above cancels first and retries silently.
      summarizerIdleTimeoutMs = 45000;
    };
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
      classifierModel = "openai-codex/gpt-6-luna";
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
      ${lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
        export LD_LIBRARY_PATH=${lib.escapeShellArg linuxAudioLibraryPath}"''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
      ''}
      case "''${1-}" in
        plugin | completions | --help | -h | --version | -V)
          exec ${pkgs.omp}/bin/omp "$@"
          ;;
      esac

      automodePath="$HOME/.omp/plugins/node_modules/@czottmann/pi-automode/extensions/auto-mode.ts"
      if [[ ! -f "$automodePath" ]]; then
        echo "omp: refusing to start without pi-automode; run rb to install it" >&2
        exit 1
      fi

      if ! ${pkgs.omp}/bin/omp plugin doctor --json >/dev/null; then
        echo "omp: refusing to start because an OMP plugin failed validation" >&2
        echo "omp: run 'omp plugin doctor' for details" >&2
        exit 1
      fi

      exec ${pkgs.omp}/bin/omp "$@"
    '';
  };
in
{
  home.packages = [ omp ] ++ lib.optional pkgs.stdenv.hostPlatform.isLinux computerUseLinux;
  dconf.settings = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    "org/gnome/desktop/interface".toolkit-accessibility = true;
  };

  # OMP writes runtime settings to this file. Keep it outside Home Manager's
  # read-only store links, and merge new Nix defaults underneath runtime edits.
  home.file.".omp/agent/config.yml".enable = false;
  home.file.".omp/agent/lsp.json".source = lspFile;
  home.file.".omp/agent/mcp.json" = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    text = builtins.toJSON {
      mcpServers.computer-use-linux = {
        command = lib.getExe computerUseLinux;
        args = [ "mcp" ];
        env = {
          COMPUTER_USE_LINUX_AGENT_NAME = "OMP";
          COMPUTER_USE_LINUX_ENABLE_SHELL = "0";
          COMPUTER_USE_LINUX_PERSIST_REMOTE_DESKTOP = "0";
        };
      };
    };
  };

  home.activation.syncOmpConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${syncConfig}/bin/sync-omp-config "$HOME/.omp/agent/config.yml"
  '';

  # pi-condense shares OMP's writable settings file. Enforce only the selected
  # summarizer while preserving every other runtime-managed setting.
  home.file.".omp/agent/settings.json".enable = false;
  home.file.".omp/agent/APPEND_SYSTEM.md".text =
    config.agent.context
    + lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''

      For screenshots in a niri session, read and use the niri-screenshot skill. Do not use computer-use tools to capture screenshots, including screenshot_after.
    '';

  home.activation.syncOmpSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${syncSettings}/bin/sync-omp-settings "$HOME/.omp/agent/settings.json"
  '';

  # pi-automode deliberately reads Pi-owned configuration even under OMP.
  # Per-project, uncommitted overrides belong in .pi/automode.local.json.
  home.file.".pi/agent/extensions/pi-automode/config.json".source = automodeConfig;

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

    piCondenseDir="$HOME/.omp/plugins/node_modules/pi-condense"
    piCondenseIndex="$piCondenseDir/index.ts"
    if [[ -f "$piCondenseIndex" ]] && ! ${lib.getExe pkgs.gnugrep} -q "timeoutController.abort(), 25_000" "$piCondenseIndex"; then
      $DRY_RUN_CMD ${lib.getExe pkgs.git} \
        -C "$piCondenseDir" \
        apply ${piCondensePatch}
    fi
  '';
}
