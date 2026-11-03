{
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  home.packages = [
    (pkgs.symlinkJoin {
      name = "${pkgs.kooha.name}-window-recording";
      paths = [ pkgs.kooha ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram "$out/bin/kooha" \
          --set KOOHA_EXPERIMENTAL window-recording

        service="$out/share/dbus-1/services/io.github.seadve.Kooha.service"
        cp --remove-destination \
          "${pkgs.kooha}/share/dbus-1/services/io.github.seadve.Kooha.service" "$service"
        substituteInPlace "$service" \
          --replace-fail "${pkgs.kooha}/bin/kooha" "$out/bin/kooha"
      '';
      inherit (pkgs.kooha) meta;
    })
  ];
}
