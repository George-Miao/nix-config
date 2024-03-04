{
  self,
  config,
  ...
}: {
  flake = {
    nixosModules = {
      desktop.imports = [
        ../shared
        ./fonts.nix
        self.unit.sys.x
        self.nixosModules.home-manager
        {
          home-manager.users.${config.user} = {
            imports = [self.homeModules.desktop];
            home.sessionVariables = {
              BROWSER = "firefox";
              TERMINAL = "alacritty";
            };
          };

          # Enable sound.
          sound.enable = true;
          hardware.pulseaudio.enable = true;
        }
      ];
    };
  };
}
