{
  pkgs,
  unit,
  ...
}:
{
  imports = [
    ../shared
    ./fonts.nix
  ];

  nixpkgs.config = {
    allowBroken = true;
  };

  # Only available on Nix-Darwin
  nix.gc.interval = [
    {
      Hour = 3;
      Minute = 15;
      Weekday = 7;
    }
  ];

  home-manager = {
    users.pop = {
      imports = [
        unit.preset.local
      ];
      programs.zsh.shellAliases = {
        copy = "pbcopy";
        paste = "pbpaste";
      };
      home.username = "pop";
      home.homeDirectory = "/Users/pop";
      home.packages = with pkgs; [
        tart
      ];
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  users.users.pop = {
    name = "pop";
    home = "/Users/pop";
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "rb" ''
      (cd $HOME/.nix-config && git add --all && sudo darwin-rebuild switch --flake .)
    '')
  ];

  system.primaryUser = "pop";
  system.defaults = {
    dock = {
      autohide = false;
      orientation = "bottom";
      magnification = true;
      largesize = 96;
      mineffect = "genie";
      minimize-to-application = true;
      launchanim = true;
      show-recents = false;
      persistent-apps = [
        "/Applications/Zen.app"
        "/Applications/Spark Desktop.app"
        "/Applications/Reeder.app"
        "/Applications/Fantastical.app"
        "${pkgs.alacritty}/Applications/Alacritty.app"
        "${pkgs.zed-editor}/Applications/Zed.app"
        "/Applications/Telegram.app"
        "/Applications/WeChat.app"
        "/System/Applications/System Settings.app"
        "/Applications/Things3.app"
        "/System/Applications/iPhone Mirroring.app"
      ];
    };

    finder = {
      QuitMenuItem = true;
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
      FXEnableExtensionChangeWarning = false;
    };

    NSGlobalDomain = {
      _HIHideMenuBar = false;
      InitialKeyRepeat = 10;
      KeyRepeat = 1;
      "com.apple.swipescrolldirection" = true;
    };

    screencapture.location = "/tmp";

    trackpad = {
      Clicking = true;
      FirstClickThreshold = 0;
      TrackpadThreeFingerDrag = true;
    };
  };
}
