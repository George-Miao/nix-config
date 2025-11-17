{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics.enable = true;
  hardware.amdgpu.opencl.enable = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
}
