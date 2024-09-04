{
  modulesPath,
  flake,
  ...
}: {
  imports = [
    flake.self.nixosModules.server
    flake.inputs.disko.nixosModules.disko

    "${modulesPath}/installer/scan/not-detected.nix"

    (flake.self.unit.sys.tailscale {isServer = true;})

    ./disk.nix
  ];

  networking = {
    hostName = "lux";
    useDHCP = true;
  };

  home-manager.users.${flake.config.user}.imports = [];

  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "Europe/Luxembourg";

  system.stateVersion = "24.05";
}
