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
        self.unit.sys.printer
        self.unit.sys.dropbox
        self.nixosModules.home-manager
        ({pkgs, ...}: {
          home-manager.users.${config.user} = {
            imports = [
              self.homeModules.local
              self.homeModules.gui
            ];

            home = {
              packages = with pkgs; [evince];
              sessionVariables = {
                BROWSER = "firefox";
                TERMINAL = "alacritty";
              };
            };
            programs.zsh.shellAliases = {
              "open" = "xdg-open";
            };
          };

          hardware.pulseaudio.enable = true;
        })
      ];
    };
  };
}
