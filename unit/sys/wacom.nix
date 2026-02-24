{ ... }:
{
  # services.xserver.wacom.enable = true;

  hardware.opentabletdriver.enable = true;

  # Required by OpenTabletDriver
  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];
}
