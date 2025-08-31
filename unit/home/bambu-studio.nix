{pkgs, ...}: let
  version = "2.2.1";
  appimageName = "Bambu_Studio_ubuntu-24.04_PR-8017.AppImage";
  zipUrl = "https://github.com/bambulab/BambuStudio/releases/download/v02.02.01.60/BambuStudio_ubuntu-24.04_PR-8017.zip";
  zipSha256 = "sha256-w3lmxein1ukB1B4ogTk/JV5ADT1VS8feIKywoOR91Nc=";
  srcZipped = pkgs.fetchzip {
    url = zipUrl;
    sha256 = zipSha256;
  };
  appimagePath = "${srcZipped}/${appimageName}";
  bambu-studio = pkgs.appimageTools.wrapType2 {
    name = "BambuStudio";
    pname = "bambustudio";
    inherit version;
    appimageContents = pkgs.appimageTools.extract {
      src = appimagePath;
    };
    src = appimagePath;
    profile = ''
      export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      export GIO_MODULE_DIR="${pkgs.glib-networking}/lib/gio/modules/"
    '';
    extraPkgs = pkgs:
      with pkgs; [
        cacert
        curl
        glib
        glib-networking
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        webkitgtk_4_1
        libglvnd
        fontconfig
        dejavu_fonts
        liberation_ttf
        libxkbcommon
        hack-font
      ];
  };
in {
  home.packages = [bambu-studio];
  home.file.".local/share/applications/bambustudio.desktop".text = ''
    [Desktop Entry]
    Name=BambuStudio
    GenericName=3D Printing Software
    Icon=BambuStudio
    Exec=bambustudio
    Terminal=false
    Type=Application
    MimeType=model/stl;model/3mf;application/vnd.ms-3mfdocument;application/prs.wavefront-obj;application/x-amf;x-scheme-handler/bambustudio;
    Categories=Graphics;3DGraphics;Engineering;
    StartupNotify=false
  '';
}
