{
  self,
  config,
  ...
}: {
  flake.nixosModules.desktop = {pkgs, ...}: {
    imports = with self.unit.sys; [
      ../shared
      ../shared/nixos.nix
      ./fonts.nix

      # x
      # i3
      hyprland
      printer
      docker
      pipewire
      keyring
      kdeconnect

      self.nixosModules.home-manager
    ];

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
        "open" = "setsid xdg-open";
      };
    };

    # hardware.pulseaudio.enable = true;
  };
}
