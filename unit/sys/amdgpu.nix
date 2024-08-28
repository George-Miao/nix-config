{
  config,
  pkgs,
  ...
}: {
  services.xserver.videoDrivers = ["amdgpu"];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;

    extraPackages = [pkgs.amdvlk];
    extraPackages32 = [pkgs.driversi686Linux.amdvlk];
  };
  boot.initrd.kernelModules = ["amdgpu"];
}
