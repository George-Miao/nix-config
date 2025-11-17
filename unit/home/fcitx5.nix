{pkgs, ...}: {
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        libsForQt5.fcitx5-qt
        fcitx5-gtk
        fcitx5-mozc
      ];
      settings = {
        globalOptions = {
          "Hotkey" = {
            "EnumerateWithTriggerKeys" = true;
            "ModifierOnlyKeyTimeout" = 250;
          };
          "Hotkey/TriggerKeys" = {
            "0" = "Super+space";
          };
          "Hotkey/EnumerateGroupForwardKeys" = {
            "0" = "Super+space";
          };
          "Hotkey/EnumerateGroupBackwardKeys" = {
            "0" = "Shift+Super+space";
          };
          "Hotkey/PrevPage" = {
            "0" = "Up";
          };
          "Hotkey/NextPage" = {
            "0" = "Down";
          };
          "Hotkey/NextCandidate" = {
            "0" = "Tab";
          };
          "Hotkey/PrevCandidate" = {
            "0" = "Shift+Tab";
          };
          "Hotkey/TogglePreedit" = {
            "0" = "Control+Alt+P";
          };
          "Behavior" = {
            "ActiveByDefault" = false;
            "resetStateWhenFocusIn" = "All";
            "ShareInputState" = "Program";
            "PreeditEnabledByDefault" = true;
            "ShowInputMethodInformation" = true;
            "showInputMethodInformationWhenFocusIn" = false;
            "CompactInputMethodInformation" = true;
            "ShowFirstInputMethodInformation" = true;
            "DefaultPageSize" = 5;
            "OverrideXkbOption" = false;
            "PreloadInputMethod" = true;
            "AllowInputMethodForPassword" = false;
            "AutoSavePeriod" = 30;
          };
        };
        inputMethod = {
          "GroupOrder"."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "shuangpin";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-us";
            Layout = "";
          };
          "Groups/0/Items/1" = {
            Name = "shuangpin";
            Layout = "";
          };
          "Groups/0/Items/2" = {
            Name = "mozc";
            Layout = "";
          };
        };
        addons = {
          keyboard = {
            globalSection = {
              PageSize = 5;
              EnableEmoji = true;
              EnableQuickPhraseEmoji = true;
              "Choose Modifier" = "Alt";
              EnableHintByDefault = true;
              UseNewComposeBehavior = true;
              EnableLongPress = true;
            };
            sections = {
              PrevCandidate = {
                "0" = "Shift+Tab";
              };
              NextCandidate = {
                "0" = "Tab";
              };
              "Hint Trigger" = {
                "0" = "Control+Alt+H";
              };
              "One Time Hint Trigger" = {
                "0" = "Control+Alt+J";
              };
              LongPressBlocklist = {
                "0" = "konsole";
                "1" = "org.kde.konsole";
              };
            };
          };
          pinyin = {
            globalSection = {
              ShuangpinProfile = "Ziranma";
              ShowShuangpinMode = true;
              PageSize = 7;
              SpellEnabled = true;
              SymbolsEnabled = true;
              ChaiziEnabled = true;
              ExtBEnabled = true;
              StrokeCandidateEnabled = true;
              CloudPinyinEnabled = true;
              CloudPinyinIndex = 2;
              CloudPinyinAnimation = true;
              KeepCloudPinyinPlaceHolder = false;
              PreeditMode = "Commit preview";
              PreeditCursorPositionAtBeginning = true;
              PinyinInPreedit = false;
              Prediction = false;
              PredictionSize = 49;
              SwitchInputMethodBehavior = "Commit default selection";
              SecondCandidate = "";
              ThirdCandidate = "";
              UseKeypadAsSelection = false;
              BackSpaceToUnselect = true;
              "Number of sentence" = 2;
              LongWordLengthLimit = 4;
              QuickPhraseKey = "semicolon";
              VAsQuickphrase = true;
              FirstRun = false;
            };
            sections = {
              ForgetWord = {
                "0" = "Control+7";
              };
              PrevPage = {
                "0" = "minus";
                "1" = "Up";
                "2" = "KP_Up";
              };
              NextPage = {
                "0" = "equal";
                "1" = "Down";
                "2" = "KP_Down";
              };
              PrevCandidate = {
                "0" = "Shift+Tab";
              };
              NextCandidate = {
                "0" = "Tab";
              };
              CurrentCandidate = {
                "0" = "space";
                "1" = "KP_Space";
              };
              CommitRawInput = {
                "0" = "Return";
                "1" = "KP_Enter";
                "2" = "Control+Return";
                "3" = "Control+KP_Enter";
                "4" = "Shift+Return";
                "5" = "Shift+KP_Enter";
                "6" = "Control+Shift+Return";
                "7" = "Control+Shift+KP_Enter";
              };
              ChooseCharFromPhrase = {
                "0" = "bracketleft";
                "1" = "bracketright";
              };
              FilterByStroke = {
                "0" = "grave";
              };
              QuickPhraseTriggerRegex = {
                "0" = ".(/|@)$";
                "1" = "^(www|bbs|forum|mail|bbs)\\.";
                "2" = "^(http|https|ftp|telnet|mailto):";
              };
              Fuzzy = {
                VE_UE = true;
                NG_GN = true;
                Inner = true;
                InnerShort = true;
                PartialFinal = true;
                PartialSp = false;
                V_U = false;
                AN_ANG = false;
                EN_ENG = false;
                IAN_IANG = false;
                IN_ING = false;
                U_OU = false;
                UAN_UANG = false;
                C_CH = false;
                F_H = false;
                L_N = false;
                L_R = false;
                S_SH = false;
                Z_ZH = false;
                Correction = "None";
              };
            };
          };
          mozc = {
            globalSection = {
              ExpandMode = "On Focus";
              ExpandKey = "Control+Alt+H";
            };
          };
        };
      };
    };
  };
}
