{
  pkgs,
  unit,
  ...
}:
{
  imports = with unit.sys; [
    ../shared
    ../shared/nixos.nix
    ./fonts.nix
    ./xdg.nix

    spacenav
    probe-rs
    flipper
    printer
    docker
    pipewire
    keyring
    kdeconnect
  ];

  home-manager.users.pop = {
    imports = with unit; [
      preset.local
      preset.gui
      home.vscode.linux.insider
      home.dropbox
    ];

    home = {
      packages = with pkgs; [
        glibc
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
}
