{pkgs, ...}: {
  imports = [./pop-wallpaper.nix];

  programs.feh.enable = true;

  systemd.user = {
    services.update-wallpaper = {
      Unit.Description = "Update wallpaper";
      Install.WantedBy = ["default.target"];

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.feh}/bin/feh --bg-fill --randomize %h/Wallpapers";
      };
    };

    timers.update-wallpaper = {
      Unit.Description = "Update wallpaper every 30 minutes";
      Install.WantedBy = ["default.target"];

      Timer = {
        OnActiveSec = 0;
        OnStartupSec = 0;
        OnUnitActiveSec = "30m";
        Persistent = true;
      };
    };
  };
}
