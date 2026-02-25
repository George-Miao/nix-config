with builtins;
let
  basename = name: substring 0 (stringLength name - 4) name;
  import_all =
    dir:
    listToAttrs (
      map (file: {
        name = basename file;
        value = import (dir + "/${file}");
      }) (filter (x: x != "default.nix") (attrNames (readDir dir)))
    );
in
rec {
  sys = import_all ./sys;
  home = import_all ./home;
  preset = rec {
    bare =
      { pkgs, inputs, ... }:
      {
        home = {
          stateVersion = "23.11";
          sessionVariables = {
            EDITOR = "vim";
          };
        };

        imports = with home; [
          git
          zsh
          lsd
        ];

        home.packages = with pkgs; [
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
    core =
      { pkgs, inputs, ... }:
      {
        home = {
          stateVersion = "23.11";
          sessionVariables = {
            EDITOR = "vim";
          };
        };

        imports = with home; [
          inputs.zen-browser.homeModules.twilight

          nix-index
          jujutsu
          cargo
          git
          starship
          zsh
          gpg
          direnv
          lsd
        ];

        home.packages = with pkgs; [
          dust
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
    local =
      { pkgs, ... }:
      {
        imports = with home; [
          # vscode
          alacritty
          zed
          rustfmt
          forgejo-cli
          syncthing
          headscale
          rbw
          gh
          typst
          gpg-agent
          kubespy

          core
        ];

        home.file."hushlogin" = {
          target = ".hushlogin";
          text = "";
        };

        home.packages =
          with pkgs;
          let
            rust = rust-bin.selectLatestNightlyWith (
              toolchain:
              toolchain.default.override {
                extensions = [ "rust-src" ];
              }
            );
          in
          [
            devbox
            codex
            nixfmt
            lean4
            bacon
            nixfmt-tree
            uv
            unrar
            devenv
            cargo-feature
            vector
            discord
            nix-search-cli
            espup
            arp-scan
            deploy-rs
            rust
            flyctl
            libiconv
            cargo-release
            dua
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
    server =
      { pkgs, ... }:
      {
        imports = [ core ];
      };

    # List of GUI packages
    gui =
      { pkgs, lib, ... }:
      {
        imports = with home; [
          bambu-studio
          zen-browser
          # wine
          fcitx5
          gtk
        ];

        home.packages = with pkgs; [
          openwebstart
          # stm32cubemx
          postman
          mpv
          qbittorrent
          # bottles-unwrapped
          teamspeak3
          # kicad
          # freecad-wayland
          appimage-run
          # gui-for-clash
          wechat-uos
          yubioath-flutter
          # chromium
          zotero
          libreoffice
          kooha
          telegram-desktop
          firefox
          pavucontrol
          darktable
        ];
      };
  };
}
