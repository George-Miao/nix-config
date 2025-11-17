{
  self,
  config,
  ...
}:
let
  user = config.user;
in
{
  flake = {
    darwinModules = {
      default = {
        imports = [
          ../shared
          ./fonts.nix
          self.darwinModules_.home-manager
          # self.unit.sys.dropbox
        ];

        home-manager = {
          users.${user} = {
            imports = [
              self.homeModules.local
              self.unit.home.vscode.darwin.insider
              self.unit.home.alacritty

              (
                { pkgs, ... }:
                {
                  home.packages = [
                    pkgs.tart
                  ];
                }
              )
            ];
            home.username = user;
            home.homeDirectory = "/Users/${user}";
          };
          useGlobalPkgs = true;
          useUserPackages = true;
        };

        nix.gc = {
          interval = {
            Day = 7;
          };
        };

        security.pam.services.sudo_local.touchIdAuth = true;
        users.users.${user} = {
          name = user;
          home = "/Users/${user}";
        };

        system.primaryUser = user;
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
              "/Users/${user}/Applications/Home Manager Apps/Alacritty.app"
              "/Users/${user}/Applications/Home Manager Apps/Visual Studio Code - Insiders.app"
              "/Applications/Telegram.app"
              "/Applications/WeChat.app"
              "/System/Applications/System Settings.app"
              "/Applications/Things3.app"
              "/Users/${user}/Applications/Home Manager Apps/Obsidian.app"
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
      };
    };
  };
}
