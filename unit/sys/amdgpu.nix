{pkgs, ...}: {
  services.xserver.videoDrivers = ["amdgpu"];
  hardware.graphics = {
    enable = true;

    extraPackages = [pkgs.amdvlk];
    extraPackages32 = [pkgs.driversi686Linux.amdvlk];
  };
  boot.initrd.kernelModules = ["amdgpu"];
}
