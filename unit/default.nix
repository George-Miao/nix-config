input @ {self, ...}:
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
    homeModules = rec {
      # List of core packages used in command line
      core = {pkgs, ...}: {
        imports = with unit.home; [
          git
          starship
          zsh
          gpg
          direnv
          yazi
        ];

        home = {
          stateVersion = "23.11";
          packages = with pkgs; [
            (rust-bin.selectLatestNightlyWith (toolchain:
              toolchain.default.override {
                extensions = ["rust-src"];
              }))
            pv
            rnr
            xdg-utils
            tree
            htop
            file
            git-crypt
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

          sessionVariables = {EDITOR = "vim";};
        };
      };

      # List of packages used for local environment, include PC's and Macs
      local = {pkgs, ...}: {
        imports = with unit.home; [
          core
          typst
          # dropbox
        ];
        home.packages = with pkgs; [
          libiconv
          cargo-release
          dua
          biome
          bitwarden-cli
          websocat
          jq
          jless
          rclone
          gh
          nil
          alejandra
          htop
          gcc
          pkg-config
        ];
      };

      # List of packages server used for servers
      server = {pkgs, ...}: {
        imports = [core];
      };

      # List of GUI packages
      gui = {pkgs, ...}: {
        imports = with unit.home; [
          fcitx5
          alacritty
          vscode
          gpg-agent
          gtk
        ];
        home.packages = with pkgs; [
          telegram-desktop
          firefox
          pavucontrol
        ];
      };
    };
  };
}
