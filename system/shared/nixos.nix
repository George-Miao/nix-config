{
  pkgs,
  unit,
  ...
}:
{
  imports = with unit.sys; [
    yubico
    ratbag
    fwupd
  ];
  home-manager.backupFileExtension = "bkup";
  boot.initrd.systemd.dbus.enable = true;
  users.users.pop = {
    extraGroups = [
      "wheel"
      "docker"
      "dialout"
      "tty"
    ];
    isNormalUser = true;
  };
  programs.nix-ld.enable = true;
  nix = {
    gc.dates = "weekly";
    optimise = {
      automatic = true;
      dates = [ "03:45" ];
    };
  };
  environment.localBinInPath = true;
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "rb" ''
      (cd $HOME/.nix-config && git add --all && sudo nixos-rebuild switch --flake .)
    '')
  ];
  systemd.settings.Manager = {
    DefaultLimitNOFILE = "8192:524288";
  };
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "8192";
    }
  ];
}
