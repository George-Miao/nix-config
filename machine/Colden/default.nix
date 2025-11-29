{
  modulesPath,
  inputs,
  unit,
  lib,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko

    "${modulesPath}/installer/scan/not-detected.nix"
    "${modulesPath}/profiles/qemu-guest.nix"

    (unit.sys.sshd)
    # (sys.tailscale {isServer = true;})

    ./disk.nix
  ];

  networking = {
    hostName = "Colden";
    useDHCP = lib.mkDefault true;
  };

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  time.timeZone = "America/New_York";

  system.stateVersion = "24.05";
}
