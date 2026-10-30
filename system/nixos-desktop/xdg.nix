{ lib, pkgs, ... }:
let
  sourceMimeTypes = [
    "plain"
    "markdown"
    "x-csrc"
    "x-chdr"
    "x-c++src"
    "x-c++hdr"
    "x-rust"
    "x-go"
    "x-python"
    "x-java"
    "x-ruby"
    "x-php"
    "x-shellscript"
    "x-nix"
    "javascript"
    "application/javascript"
    "application/typescript"
    "typescript"
    "css"
    "application/json"
    "application/yaml"
    "yaml"
    "application/toml"
    "application/xml"
    "xml"
  ];
  map =
    lib.genAttrs (builtins.map (
      mime: if lib.hasInfix "/" mime then mime else "text/${mime}"
    ) sourceMimeTypes) (_: "dev.zed.Zed.desktop")
    // {
      "inode/directory" = "org.gnome.Nautilus.desktop";
      "image/x-sony-arw" = "org.gnome.eog.desktop";
      "image/jpeg" = "org.gnome.eog.desktop";
      "image/png" = "org.gnome.eog.desktop";
      "image/gif" = "org.gnome.eog.desktop";
      "image/webp" = "org.gnome.eog.desktop";
      "image/bmp" = "org.gnome.eog.desktop";
      "image/tiff" = "org.gnome.eog.desktop";
      "image/svg+xml" = "org.gnome.eog.desktop";
      "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      "x-scheme-handler/spotify" = "spotifast.desktop";
      "application/pdf" = "org.gnome.Evince.desktop";
      "x-scheme-handler/http" = "zen-twilight.desktop";
      "x-scheme-handler/https" = "zen-twilight.desktop";
      "x-scheme-handler/chrome" = "zen-twilight.desktop";
      "text/html" = "zen-twilight.desktop";
      "application/x-extension-htm" = "zen-twilight.desktop";
      "application/x-extension-html" = "zen-twilight.desktop";
      "application/x-extension-shtml" = "zen-twilight.desktop";
      "application/xhtml+xml" = "zen-twilight.desktop";
      "application/x-extension-xhtml" = "zen-twilight.desktop";
      "application/x-extension-xht " = "zen-twilight.desktop";
    };
in
{
  home-manager.users.pop.xdg.mimeApps = {
    enable = true;
    defaultApplications = map;
    associations = {
      added = map;
    };
  };
}
