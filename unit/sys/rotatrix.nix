{ pkgs, ... }:
let
  pname = "rotatrix";
  version = "1.5.1";
  src = ../../assets/Rotatrix-linux-x86_64.AppImage;
  appimageContents = pkgs.appimageTools.extract {
    inherit pname version src;
  };
  rotatrixConfig = pkgs.writeText "rotatrix-config.yaml" ''
    global:
      active_window_command: "${pkgs.niri}/bin/niri msg -j focused-window | ${pkgs.jq}/bin/jq -r '.app_id // empty'"
  '';
  rotatrixInit = pkgs.writeShellScript "rotatrix-init" ''
    config="''${XDG_DATA_HOME:-$HOME/.local/share}/Rotatrix/config.yaml"

    if [[ ! -e "$config" && ! -L "$config" ]]; then
      ${pkgs.coreutils}/bin/install -Dm644 ${rotatrixConfig} "$config"
    fi
  '';
  rotatrixApp = pkgs.appimageTools.wrapType2 {
    inherit pname version src;
    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/RotatrixApp.desktop \
        $out/share/applications/RotatrixApp.desktop
      install -m 444 -D ${appimageContents}/RotatrixApp.png \
        $out/share/icons/hicolor/512x512/apps/RotatrixApp.png
    '';
  };
  rotatrix = pkgs.symlinkJoin {
    name = "${pname}-${version}";
    paths = [ rotatrixApp ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      rm "$out/bin/rotatrix"
      makeWrapper ${rotatrixApp}/bin/rotatrix "$out/bin/rotatrix" \
        --run ${rotatrixInit}
    '';
  };
  udevRules = [
    (pkgs.writeTextDir "lib/udev/rules.d/70-rotatrix.rules" ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="1108", MODE="0660", TAG+="uaccess"
    '')
    (pkgs.writeTextDir "lib/udev/rules.d/71-rotatrix-input.rules" ''
      KERNEL=="event*", SUBSYSTEM=="input", MODE="0660", GROUP="input", TAG+="uaccess"
      KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", MODE:="0660", GROUP:="input", TAG+="uaccess"
    '')
  ];
in
{
  environment.systemPackages = [
    pkgs.nssTools
    rotatrix
  ];

  home-manager.users.pop.systemd.user.services.rotatrix = {
    Unit.Description = "Rotatrix desktop controller";
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${rotatrix}/bin/rotatrix";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };

  services.udev.packages = udevRules;
}
