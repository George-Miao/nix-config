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
      (import ./xdg.nix {inherit config;})

      # x
      # i3
      probe-rs
      flipper
      hyprland
      printer
      docker
      pipewire
      keyring
      kdeconnect

      self.nixosModules.home-manager
    ];

    # i18n = let
    #   EN = "en_US.UTF-8/UTF-8";
    #   CN = "zh_CN.UTF-8/UTF-8";
    #   JP = "ja_JP.UTF-8/UTF-8";
    # in {
    #   supportedLocales = ["all" EN CN JP];
    # };

    # boot.loader.grub.theme = pkgs.grub2-themes.hyprland;

    home-manager.users.${config.user} = {
      imports = [
        self.homeModules.local
        self.homeModules.gui
        self.unit.home.wpaperd
        self.unit.home.vscode.linux.insider
      ];

      home = {
        packages = with pkgs; [
          plex-desktop
          usbutils
          grub2
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
