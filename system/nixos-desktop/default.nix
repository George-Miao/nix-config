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
        self.unit.sys.docker
        self.nixosModules.home-manager
        ({pkgs, ...}: {
          home-manager.users.${config.user} = {
            imports = [
              ./xdg.nix
              self.homeModules.local
              self.homeModules.gui
              self.unit.home.wpaperd
              self.unit.home.vscode.linux.insider
            ];

            home = {
              packages = with pkgs; [
                evince
                gnome-clocks
                eog
                gnome-2048
              ];
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
