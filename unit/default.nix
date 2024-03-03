{ self, ... }:

with builtins;

let
  basename = name: substring 0 (stringLength name - 4) name;
  import_all = dir: listToAttrs
    (map
      (file: {
        name = basename file;
        value = import (dir + "/${file}");
      })
      (filter (x: x != "default.nix") (attrNames (readDir dir)))
    );
in
{
  flake = {
    unit = {
      home = import_all ./home;
      sys = import_all ./sys;
    };
    homeModules = with self.unit.home; {
      core = {
        # List of core packages used in command line
        imports = [
          git
          starship
          zsh
          gpg
          ({ pkgs, ... }: {
            home.stateVersion = "23.11";
            home.packages = with pkgs; [
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

        home.sessionVariables = {
          EDITOR = "vim";
        };
      };
      desktop = {
        # List of desktop, mostly GUI packages
        imports = [
          self.homeModules.core
          alacritty
          vscode
          i3
          rofi
          picom
          gpg-agent
          ({ pkgs, ... }: {
            home.packages = with pkgs; [
              gh
              arandr
              firefox
              pavucontrol
              nil
              nixpkgs-fmt
            ];
          })
        ];
      };
      server = {
        # List of server packages
        imports = [
          self.homeModules.core
        ];
      };
    };
  };
}
