{
  modulesPath,
  flake,
  ...
}: {
  imports = with flake.self.unit.sys; let
    vec = vector {
      hostname = "YUL";
      include_units = ["zurg_rclone"];
      extra_inputs = ["docker_with_labels"];
      extra_groups = ["docker"];
      extra_settings = {
        sources.docker = {
          type = "docker_logs";
        };
        transforms.docker_with_labels = {
          type = "remap";
          inputs = ["docker"];
          source = ''
            .service, err = replace(.container_name, r'^(?<service>.*?)\.\d+\..*', "$$service")
          '';
        };
      };
    };
  in [
    flake.self.nixosModules.server
    flake.inputs.disko.nixosModules.disko

    "${modulesPath}/installer/scan/not-detected.nix"

    vec
    caprover
    (tailscale {isServer = true;})
    (scrutiny {devices = ["/dev/nvme0" "/dev/nvme1"];})
    (zurg_rclone "/data/zurg")

    ./disk.nix
  ];

  home-manager.users.${flake.config.user}.imports = [];

  networking = let
    mail_ports = [25 110 143 46 465 587 993 995 4190];
  in {
    hostName = "YUL";
    useDHCP = true;
    firewall = {
      allowedTCPPorts = mail_ports;
      allowedUDPPorts = mail_ports;
    };
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
