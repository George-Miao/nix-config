{ lib, ... }:
{
  networking.hostName = "Kong";

  nixpkgs.hostPlatform = "aarch64-darwin";

  services.nix-daemon.logFile = "/var/log/nix-daemon.log";

  system.stateVersion = 6;

  nix.linux-builder.enable = true;

  nix.settings.substituters = [
    # "https://mirror.sjtu.edu.cn/nix-channels/store"
    # status: https://mirror.sjtu.edu.cn/

    # status: https://mirrors.tuna.tsinghua.edu.cn/
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"

    # status: https://mirrors.ustc.edu.cn/status/
    "https://mirrors.ustc.edu.cn/nix-channels/store"
  ];

  system.defaults.dock.orientation = lib.mkForce "right";
}
