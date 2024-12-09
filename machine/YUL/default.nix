{
  modulesPath,
  flake,
  ...
}: {
  imports = with flake.self.unit.sys; [
    flake.self.nixosModules.server
    flake.inputs.disko.nixosModules.disko

    "${modulesPath}/installer/scan/not-detected.nix"

    (tailscale {isServer = true;})
    caprover

    ./disk.nix
  ];

  home-manager.users.${flake.config.user}.imports = [];

  networking = {
    hostName = "YUL";
    useDHCP = true;
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      efiInstallAsRemovable = true;
      efiSupport = true;
      device = "nodev";
    };
  };

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "America/New_York";

  system.stateVersion = "24.11";
}
