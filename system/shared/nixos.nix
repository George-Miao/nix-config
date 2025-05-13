{flake, ...}: {
  imports = with flake.self.unit.sys; [
    yubico
    ratbag
  ];
  home-manager.backupFileExtension = "bkup";
  boot.initrd.systemd.dbus.enable = true;
  users.users.${flake.config.user} = {
    extraGroups = ["wheel" "docker" "dialout" "tty"];
    isNormalUser = true;
  };
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
