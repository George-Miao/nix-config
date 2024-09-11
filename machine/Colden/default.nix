{
  modulesPath,
  flake,
  lib,
  secrets,
  ...
}: let
  sys = flake.self.unit.sys;
in {
  imports = [
    flake.self.nixosModules.server
    flake.inputs.disko.nixosModules.disko

    "${modulesPath}/installer/scan/not-detected.nix"
    "${modulesPath}/profiles/qemu-guest.nix"

    (sys.tailscale {isServer = true;})
    (sys.forrit secrets.syr.forrit)

    ./disk.nix
  ];

  networking = {
    hostName = "Colden";
    useDHCP = lib.mkDefault true;
  };

  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  time.timeZone = "America/New_York";

  system.stateVersion = "24.05";
}
