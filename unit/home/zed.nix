{
  pkgs,
  lib,
  secrets,
  ...
}:
{
  programs.zed-editor =
    with builtins;
    let
      swapCtrlCmd =
        key: if match ".*ctrl.*" key != null then replaceStrings [ "ctrl" ] [ "cmd" ] key else null;
      handleKeymap = map (
        m:
        let
          b = lib.attrsets.concatMapAttrs (k: v: {
            ${k} = v;
            ${swapCtrlCmd k} = v;
          }) m.bindings;
        in
        m // { bindings = b; }
      );
    in
    {
      enable = true;
      package = pkgs.zed-editor;
      mutableUserKeymaps = false;
      mutableUserSettings = false;
      userSettings = {
        text_rendering_mode = "grayscale";
        format_on_save = "on";
        context_servers = {
          mcp-server-github = {
            settings = {
              github_personal_access_token = secrets.github.zed_mcp_token;
            };
          };
        };
        agent = {
          dock = "left";
          default_profile = "write";
          default_model = {
            provider = "copilot_chat";
            model = "claude-sonnet-4.5";
          };
          play_sound_when_agent_done = true;
          model_parameters = [ ];
          tool_permissions = {
            tools = {
              fetch = {
                default = "confirm";
                always_allow = [
                  {
                    pattern = "docs\\.rs";
                  }
                  {
                    pattern = "github\\.com";
                  }
                ];
                always_deny = [
                  {
                    pattern = "internal\\.company\\.com";
                  }
                ];
              };
              terminal = {
                always_allow =
                  let
                    cmds = [
                      "ls"
                      "wc"
                      "grep"
                      "cat"
                      "head"
                      "tail"
                      "less"
                      "bat"
                      "awk"
                      "sed"
                    ];
                  in
                  [
                    {
                      pattern = "^cargo\\s+(build|nextest|test|check|clippy|expand|bench)";
                    }
                    {
                      pattern = "^npm\\s+(install|test|run)";
                    }
                    {
                      pattern = "^verus";
                    }
                    {
                      pattern = "cd\\s+compio";
                    }
                    {
                      pattern = "^timeout\\s+";
                    }
                  ]
                  ++ builtins.map (c: { pattern = "^${c}(\\s|$)"; }) cmds;
              };
            };
          };
        };
        git = {
          inline_blame = {
            padding = 30;
            show_commit_summary = true;
          };
        };
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        project_panel = {
          dock = "right";
          indent_size = 16;
          auto_fold_dirs = false;
        };
        debugger = {
          dock = "left";
        };
        file_finder = {
          modal_max_width = "medium";
        };
        scrollbar = {
          show = "never";
        };
        tab_bar = {
          show = true;
          show_nav_history_buttons = false;
        };
        collaboration_panel = {
          dock = "right";
        };
        outline_panel = {
          dock = "right";
        };
        git_panel = {
          sort_by_path = true;
          dock = "left";
          tree_view = true;
        };
        terminal = {
          dock = "bottom";
          font_size = 12.0;
          font_family = "Cascadia Code";
          cursor_shape = "bar";
          env = {
            EDITOR = "${pkgs.zed-editor}/bin/zed --wait";
          };
        };
        minimap = {
          display_in = "active_editor";
          show = "always";
        };
        tabs = {
          file_icons = true;
          git_status = true;
          show_diagnostics = "errors";
        };
        theme = {
          mode = "system";
          light = "Base16 Solarized Light";
          dark = "Ayu Dark";
        };
        diagnostics = {
          include_warnings = true;
          inline = {
            enabled = true;
          };
        };
        cursor_blink = false;
        vertical_scroll_margin = 5;
        tab_size = 2;
        base_keymap = "VSCode";
        ui_font_size = 16;
        buffer_font_size = 15;
        cursor_shape = "block";
        preferred_line_length = 120;
        remove_trailing_whitespace_on_save = true;
        show_whitespaces = "none";
        show_edit_predictions = false;
        edit_predictions = {
          provider = "copilot";
          mode = "subtle";
        };
        gutter = {
          min_line_number_digits = 3;
        };
        indent_guides = {
          coloring = "indent_aware";
        };
        inlay_hints = {
          enabled = false;
        };
        languages =
          let
            disablePrettier = {
              prettier = {
                allowed = false;
              };
            };
            content = {
              soft_wrap = "preferred_line_length";
              remove_trailing_whitespace_on_save = false;
            };
          in
          {
            Kdl = {
              tab_size = 4;
            };
            Markdown = content;
            Typst = content;
            Nix = {
              language_servers = [
                "nil"
                "!nixd"
              ];
            };
            Rust = {
              tab_size = 4;
            };
            TypeScript = disablePrettier;
            JavaScript = disablePrettier;
            TSX = disablePrettier;
          };
        lsp = {
          rust-analyzer = {
            enable_lsp_tasks = true;
          };
          tinymist = {
            initialization_options = {
              preview = {
                background = {
                  enabled = true;
                };
              };
            };
          };
        };
        file_types = {
          plaintext = [
            "LICENSE"
          ];
          properties = [
            "MoeDarkrc"
            "*.kvconfig"
          ];
          html = [
            "*.html"
            "*.swig"
          ];
          i3 = [
            "config"
          ];
          jsonc = [
            "*.json"
            "*.hujson"
          ];
        };
        file_scan_exclusions = [
          "**/.git"
          "**/.svn"
          "**/.hg"
          "**/CVS"
          "**/.DS_Store"
          "**/Thumbs.db"
          "**/.classpath"
          "**/.settings"
          "**/out"
          "**/dist"
          "**/.husky"
          "**/.turbo"
          "**/.vscode-test"
          "**/.vscode"
          "**/.next"
          "**/.storybook"
          "**/.tap"
          "**/.nyc_output"
          "**/report"
          "**/node_modules"
        ];
      };
      userKeymaps = handleKeymap [
        {
          bindings = {
            "ctrl-," = "zed::OpenSettingsFile";
            "ctrl-alt-," = "zed::OpenSettings";
            "ctrl-{" = "pane::ActivatePreviousItem";
            "ctrl-}" = "pane::ActivateNextItem";
            ctrl-p = "file_finder::Toggle";
            ctrl-shift-k = "zed::OpenKeymapFile";
            ctrl-shift-j = "terminal_panel::ToggleFocus";
          };
        }
        {
          context = "Workspace";
          bindings = {
            ctrl-shift-s = "workspace::SaveWithoutFormat";
            ctrl-shift-n = null;
          };
        }
        {
          context = "Pane";
          bindings = {
            ctrl-alt-_ = null;
            ctrl-alt-- = null;
          };
        }
        {
          context = "ProjectPanel";
          bindings = {
            ctrl-shift-n = "project_panel::NewDirectory";
          };
        }
        {
          context = "Editor";
          bindings = {
            ctrl-space = "editor::ShowCompletions";
            alt-enter = "editor::GoToDefinition";
            ctrl-enter = "editor::Hover";
            ctrl-alt-enter = "editor::FindAllReferences";
            alt-down = [
              "editor::MoveDownByLines"
              {
                lines = 3;
              }
            ];
            alt-up = [
              "editor::MoveUpByLines"
              {
                lines = 3;
              }
            ];
            alt-f = "editor::Format";
            alt-backspace = "editor::DeleteToPreviousWordStart";
            alt-shift-left = "editor::SelectToPreviousWordStart";
            alt-shift-right = "editor::SelectToNextWordEnd";
            ctrl-k = "editor::DeleteLine";
            super-k = null;
            alt-left = "editor::MoveToPreviousWordStart";
            alt-right = "editor::MoveToNextWordEnd";
            ctrl-up = "editor::MoveLineUp";
            ctrl-down = "editor::MoveLineDown";
            ctrl-right = "editor::MoveToEndOfLine";
            ctrl-left = "editor::MoveToBeginningOfLine";
            ctrl-alt-up = "editor::DuplicateLineUp";
            ctrl-alt-down = "editor::DuplicateLineDown";
            ctrl-alt-right = "pane::GoForward";
            ctrl-alt-left = "pane::GoBack";
            ctrl-e = "editor::GoToDiagnostic";
            ctrl-alt-e = "editor::GoToPreviousDiagnostic";
            alt-i = "editor::GoToImplementation";
            ctrl-shift-enter = "editor::NewlineAbove";
            ctrl-shift-right = [
              "editor::SelectToEndOfLine"
              {
                stop_at_soft_wraps = true;
              }
            ];
            ctrl-shift-left = [
              "editor::SelectToBeginningOfLine"
              {
                stop_at_soft_wraps = true;
                stop_at_indent = true;
              }
            ];
          };
        }
        {
          context = "Editor && !BufferSearchBar";
          bindings = {
            ctrl-i = "assistant::InlineAssist";
            shift-enter = "editor::NewlineBelow";
          };
        }
        {
          context = "Editor && multibuffer";
          bindings = {
            ctrl-shift-up = "editor::ExpandExcerptsUp";
            ctrl-shift-down = "editor::ExpandExcerptsDown";
          };
        }
        {
          context = "Editor && extension == rs";
          bindings = {
            alt-e = "editor::ExpandMacroRecursively";
          };
        }
        {
          context = "GitDiff";
          bindings = {
            ctrl-s = "git::StageAndNext";
          };
        }
      ];
    };

  programs.zsh.shellAliases."zed" = "${pkgs.zed-editor}/bin/zeditor";
}
