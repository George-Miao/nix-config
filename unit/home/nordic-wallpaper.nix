{pkgs, ...}: let
  fetched = pkgs.fetchFromGitHub {
    owner = "linuxdotexe";
    repo = "nordic-wallpapers";
    rev = "78b242f58faf31541ba4d76926849253b4d2e979";
    sha256 = "1ic1bx365szbl90mnvclmilgyr48k7vdlwd7qqibgcdp03kqvb41";
  };
in {
  home.file.wallpapers = {
    enable = true;
    target = "Wallpapers";
    source = fetched + "/wallpapers";
  };
}
