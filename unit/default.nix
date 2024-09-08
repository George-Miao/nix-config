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
      bare = {pkgs, ...}: {
        home = {
          stateVersion = "23.11";
          sessionVariables = {
            EDITOR = "vim";
          };
        };

        imports = with unit.home; [git zsh];

        home.packages = with pkgs; [
          lsd
          dig
          file
          openssl
          bat
          vim
          wget
          curl
        ];
      };
      # List of core packages used in command line
      core = {pkgs, ...}: {
        home = {
          # See https://nix-community.github.io/home-manager/options.xhtml#opt-home.stateVersion
          stateVersion = "23.11";
          sessionVariables = {
            EDITOR = "vim";
          };
        };

        imports = with unit.home; [
          cargo
          git
          starship
          zsh
          gpg
          direnv
          yazi
        ];

        home.packages = with pkgs; let
          rust = rust-bin.selectLatestNightlyWith (toolchain:
            toolchain.default.override {
              extensions = ["rust-src"];
            });
        in [
          rust
          lsd
          dig
          pv
          rnr
          xdg-utils
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
      };

      # List of packages used for local environment, include nixos and darwin
      local = {pkgs, ...}: {
        imports = with unit.home; [
          gh
          core
          typst
          dropbox
        ];

        home.packages = with pkgs; [
          libiconv
          cargo-release
          dua
          biome
          # bitwarden-cli # Build failed after Python 3.12
          websocat
          jq
          jless
          rclone
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
          gpg-agent
          gtk
        ];

        home.packages = with pkgs; [
          telegram-desktop
          firefox
          pavucontrol
          darktable
        ];
      };
    };
  };
}
