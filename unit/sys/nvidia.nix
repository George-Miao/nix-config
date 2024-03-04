{config, ...}: {

services.xserver.videoDrivers = ["nvidia"];
hardware.opengl = { enable = true; driSupport = true; driSupport32Bit = true; };
hardware.nvidia = {
  modesetting.enable = true;
  powerManagement.enable = false;
  powerManagement.finegrained = false;
  
};
boot.initrd.kernelModules = [ "nvidia" ];
boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
}
