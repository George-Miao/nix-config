{
  modulesPath,
  flake,
  ...
}:
{
  imports = with flake.self.unit.sys; [
    flake.self.nixosModules.server
    flake.inputs.disko.nixosModules.disko

    "${modulesPath}/installer/scan/not-detected.nix"
    "${modulesPath}/profiles/qemu-guest.nix"

    netbird-server
    # (tailscale {isServer = true;})
    (vector {
      hostname = "LAX-2";
      include_units = [
        "netbird-management"
        "netbird-signal"
        "nginx"
        "cloud-config"
        "cloud-init"
      ];
    })

    ./disk.nix
  ];

  boot.initrd.availableKernelModules = [
    "uhci_hcd"
    "ehci_pci"
    "ahci"
    "virtio_pci"
    "sr_mod"
    "virtio_blk"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";

  services.cloud-init = {
    enable = true;
    network.enable = true;
  };

  networking.hostName = "LAX-2";

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  home-manager.users.${flake.config.user}.imports = [ ];

  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "America/Los_Angeles";

  system.stateVersion = "23.11";
}
