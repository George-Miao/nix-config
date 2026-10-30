{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  nvidiaEnabled = builtins.elem "nvidia" config.services.xserver.videoDrivers;
  nvidiaPackage =
    inputs.waydroid-nvidia.packages.${pkgs.stdenv.hostPlatform.system}.waydroid-nvidia-full;
in
{
  virtualisation.waydroid = {
    enable = true;
    package = if nvidiaEnabled then nvidiaPackage else pkgs.waydroid-nftables;
  };

  boot.kernelModules = lib.mkIf nvidiaEnabled [ "udmabuf" ];

  assertions = lib.optionals nvidiaEnabled [
    {
      assertion = config.hardware.nvidia.open && config.hardware.nvidia.modesetting.enable;
      message = "Waydroid NVIDIA needs open NVIDIA kernel modules and DRM modesetting.";
    }
  ];

  services.udev.packages = lib.mkIf nvidiaEnabled [ nvidiaPackage ];
  systemd.tmpfiles.packages = lib.mkIf nvidiaEnabled [ nvidiaPackage ];
  systemd.user.services.wd-venus = lib.mkIf nvidiaEnabled {
    description = "Waydroid NVIDIA Venus render server";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${nvidiaPackage}/lib/waydroid-nvidia/virgl_test_server --venus --multi-clients --socket-path /run/waydroid-venus/venus.sock";
      Environment = [
        "RENDER_SERVER_EXEC_PATH=${nvidiaPackage}/lib/waydroid-nvidia/virgl_render_server"
        "LD_LIBRARY_PATH=${nvidiaPackage}/lib/waydroid-nvidia:${pkgs.vulkan-loader}/lib"
      ];
      Restart = "on-failure";
      RestartSec = 1;
    };
  };

  environment.systemPackages = [
    pkgs.bindfs
    pkgs.waydroid-helper
  ];

  # Show host ownership without changing Android file ownership.
  fileSystems."/data/waydroid" = {
    device = "${config.users.users.pop.home}/.local/share/waydroid/data/media/0";
    fsType = "fuse.bindfs";
    options = [
      "mirror=pop"
      "nofail"
      "x-systemd.automount"
    ];
  };

  systemd = {
    packages = [ pkgs.waydroid-helper ];
    services.waydroid-mount.wantedBy = [ "multi-user.target" ];
  };

  home-manager.users.pop.systemd.user.services.waydroid-monitor = {
    Unit = {
      Description = "Waydroid session D-Bus monitor";
      After = [ "dbus.service" ];
    };
    Install.WantedBy = [ "default.target" ];
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.waydroid-helper}/bin/waydroid-helper --start-monitor";
      StandardOutput = "journal";
      StandardError = "journal";
      Restart = "always";
      RestartSec = 5;
    };
  };
}
