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
          self.darwinModules_.home-manager
        ];

        home-manager = {
          users.${user} = {
            imports = [
              self.homeModules.local
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
            autohide = true;
            orientation = "right";
          };

          finder = {
            AppleShowAllExtensions = true;
            _FXShowPosixPathInTitle = true;
            FXEnableExtensionChangeWarning = false;
          };

          NSGlobalDomain = {
            _HIHideMenuBar = true;
            "com.apple.swipescrolldirection" = false;
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
