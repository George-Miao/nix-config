{
  self,
  config,
  ...
}: {
  flake = {
    nixosModules = {
      desktop.imports = [
        ../shared
        ../shared/nixos.nix
        ./fonts.nix
        # self.unit.sys.x
        # self.unit.sys.i3
        self.unit.sys.hyprland
        self.nixosModules.home-manager
        {
          home-manager.users.${config.user} = {
            imports = [self.homeModules.local self.homeModules.gui];
            home.sessionVariables = {
              BROWSER = "firefox";
              TERMINAL = "alacritty";
            };
          };

          hardware.pulseaudio.enable = true;
        }
      ];
    };
  };
}
