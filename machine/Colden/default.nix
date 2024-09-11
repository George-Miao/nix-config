{
  modulesPath,
  flake,
  lib,
  secrets,
  ...
}: {
  imports = [
    flake.self.nixosModules.server
    flake.inputs.disko.nixosModules.disko

    "${modulesPath}/installer/scan/not-detected.nix"
    "${modulesPath}/profiles/qemu-guest.nix"

    (flake.self.unit.sys.tailscale {isServer = true;})

    ./disk.nix
  ];

  networking = {
    hostName = "Colden";
    useDHCP = lib.mkDefault true;
  };

  home-manager.users.${flake.config.user}.imports = [
    (flake.self.unit.home.forrit secrets.syr.forrit)
  ];

  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  time.timeZone = "America/New_York";

  system.stateVersion = "24.05";
}
