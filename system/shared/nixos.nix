{flake, ...}: {
  imports = with flake.self.unit.sys; [
    yubico
    ratbag
    fwupd
  ];
  home-manager.backupFileExtension = "bkup";
  boot.initrd.systemd.dbus.enable = true;
  users.users.${flake.config.user} = {
    extraGroups = ["wheel" "docker" "dialout" "tty"];
    isNormalUser = true;
  };
  programs.nix-ld.enable = true;
  nix = {
    optimise = {
      automatic = true;
      dates = ["03:45"];
    };
    gc = {
      dates = "weekly";
    };
  };
}
