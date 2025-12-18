{ pkgs, config, ... }:
{
  environment.systemPackages = [
    pkgs.nvtopPackages.nvidia
  ]; 
  hardware = {
    graphics.enable = true;
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      open = true;
      nvidiaSettings = true;
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
    };
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  boot = {
    initrd.kernelModules = [ 
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
      "i2c-nvidia_gpu" 
    ];
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  };
}
