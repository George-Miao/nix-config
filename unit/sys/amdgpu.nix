{pkgs, ...}: {
  services.xserver.videoDrivers = ["amdgpu"];
  hardware.graphics = {
    enable = true;

    extraPackages = [pkgs.amdvlk];
    extraPackages32 = [pkgs.driversi686Linux.amdvlk];
  };
  hardware.amdgpu.opencl.enable = true;
  boot.initrd.kernelModules = ["amdgpu"];
}
