{
  config,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3d67106a-c23a-4a52-b139-5246cd17d722";
    fsType = "btrfs";
    options = ["compress=zstd" "subvol=root"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/3d67106a-c23a-4a52-b139-5246cd17d722";
    fsType = "btrfs";
    options = ["compress=zstd" "subvol=home"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/3d67106a-c23a-4a52-b139-5246cd17d722";
    fsType = "btrfs";
    options = ["compress=zstd" "subvol=nix"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4571-94DA";
    fsType = "vfat";
  };

  swapDevices = [];

  networking.useDHCP = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
}
