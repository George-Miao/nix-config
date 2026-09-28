{ pkgs, ... }:
let
  mailspring = pkgs.mailspring.overrideAttrs (old: {
    # Ignore another Nix generation's Electron path on a second launch.
    postPatch = (old.postPatch or "") + ''
      substituteInPlace app/src/browser/main.js \
        --replace-fail \
          "if (path.resolve(arg) === resourcePath) {" \
          "if (path.resolve(arg) === resourcePath || path.resolve(arg).endsWith('/share/mailspring/resources/app.asar')) {"
    '';

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
