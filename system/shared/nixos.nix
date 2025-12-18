{
  pkgs,
  inputs,
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
}
