{
  lib,
  pkgs,
  ...
}: {
  launchd.agents.maestral = {
    script = ''
      exec ${lib.getBin pkgs.maestral}/bin/maestral start -fv
    '';
    serviceConfig = {
      Label = "app.maestral";
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/var/log/maestral.out.log";
      StandardErrorPath = "/var/log/maestral.err.log";
    };
  };
}
