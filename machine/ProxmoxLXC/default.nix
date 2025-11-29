{
  pkgs,
  unit,
  modulesPath,
  ...
}:
{
  imports = [
    unit.sys.sshd
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  virtualisation.lxc = {
    enable = true;
    lxcfs.enable = true;
    defaultConfig = ''
      lxc.include = ${pkgs.lxcfs}/share/lxc/config/common.conf.d/00-lxcfs.conf
    '';
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "23.11";
}
