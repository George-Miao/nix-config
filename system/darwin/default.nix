{
  self,
  config,
  ...
}: let
  user = config.user;
in {
  flake = {
    darwinModules = {
      default = {
        imports = [
          ../shared
          ./fonts.nix
          self.darwinModules_.home-manager
        ];

        home-manager = {
          users.${user} = {
            imports = [
              self.homeModules.local
              self.unit.home.vscode.darwin.insider
              self.unit.home.alacritty

              ({pkgs, ...}: {
                home.packages = [
                  pkgs.darwin.apple_sdk.frameworks.SystemConfiguration
                  pkgs.darwin.apple_sdk.frameworks.Security
                  pkgs.tart
                ];
              })
            ];
            home.username = user;
            home.homeDirectory = "/Users/${user}";
          };
          useGlobalPkgs = true;
          useUserPackages = true;
        };

        services.nix-daemon.enable = true;

        nix.gc = {
          interval = {
            Day = 7;
          };
        };

        security.pam.enableSudoTouchIdAuth = true;
        users.users.${user} = {
          name = user;
          home = "/Users/${user}";
        };

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
              "/Applications/Arc.app"
              "/Applications/Spark Desktop.app"
              "/Applications/Reeder.app"
              "/Applications/Fantastical.app"
              "/Users/${user}/Applications/Home Manager Apps/Alacritty.app"
              "/Users/${user}/Applications/Home Manager Apps/Visual Studio Code - Insiders.app"
              "/Applications/Telegram.app"
              "/Applications/WeChat.app"
              "/System/Applications/System Settings.app"
              "/Applications/Things3.app"
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
            "com.apple.swipescrolldirection" = true;
          };

          screencapture.location = "/tmp";

          trackpad = {
            Clicking = true;
            TrackpadThreeFingerDrag = true;
          };
        };
      };
    };
  };
}
