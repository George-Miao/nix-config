{
  pkgs,
  # self',
  modulesPath,
  ...
}: {
  imports = [
    # self'.nixosModules.server
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  proxmoxLXC.privileged = true;

  virtualisation.lxd = {
    enable = true;
    zfsSupport = true;
    recommendedSysctlSettings = true;
  };

  virtualisation.lxc = {
    enable = true;
    lxcfs.enable = true;
    defaultConfig = ''
      lxc.include = ${pkgs.lxcfs}/share/lxc/config/common.conf.d/00-lxcfs.conf
    '';
  };

  system.stateVersion = "23.11";
}
