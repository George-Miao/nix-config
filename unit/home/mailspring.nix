{ pkgs, ... }:
let
  mailspring = pkgs.mailspring.overrideAttrs (old: {
    postFixup = ''
      substituteInPlace $out/share/applications/Mailspring.desktop \
        --replace-fail "Exec=mailspring" "Exec=$out/bin/mailspring --password-store=gnome-libsecret"
    '';
  });
in
{
  home.packages = [
    mailspring
  ];
}
