{ pkgs, ... }:
{
  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" ];
  };
  home.packages = [ pkgs.gcr ];
}
