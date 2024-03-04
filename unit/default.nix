{self, ...}:
with builtins; let
  basename = name: substring 0 (stringLength name - 4) name;
  import_all = dir:
    listToAttrs (map (file: {
      name = basename file;
      value = import (dir + "/${file}");
    }) (filter (x: x != "default.nix") (attrNames (readDir dir))));
in {
  flake = rec {
    unit = {
      home = import_all ./home;
      sys = import_all ./sys;
    };
    homeModules = with unit.home; rec {
      core = {
        # List of core packages used in command line
        imports = [
          git
          starship
          zsh
          gpg
          ({pkgs, ...}: {
            home.stateVersion = "23.11";
            home.packages = with pkgs; [
              (rust-bin.stable.latest.default.override {
                extensions = ["rust-src"];
              })
              git-crypt
              gcc
              pkg-config
              openssl
              bat
              vim
              xh
              wget
              curl
              fd
              ouch
              ripgrep
            ];
          })
        ];

        home.sessionVariables = {EDITOR = "vim";};
      };
      desktop = {
        # List of desktop, mostly GUI packages
        imports = [
          core
          fcitx5
          alacritty
          vscode
          i3
          rofi
          picom
          gpg-agent
          gtk
          ({pkgs, ...}: {
            home.packages = with pkgs; [
              gh
              telegram-desktop
              firefox
              pavucontrol
              nil
              alejandra
            ];
          })
        ];
      };
      server = {
        # List of server packages
        imports = [core];
      };
    };
  };
}
