{ pkgs, ... }:
let
  orca =
    if pkgs.stdenv.hostPlatform.isDarwin then
      pkgs.orca.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          rm "$out/bin/orca"
          cat > "$out/bin/orca" <<EOF
          #!${pkgs.runtimeShell}
          exec "$out/Applications/Orca.app/Contents/MacOS/Orca" "\$@"
          EOF
          chmod +x "$out/bin/orca"
        '';
      })
    else
      pkgs.orca;
in
{
  home.packages = [ orca ];
}
