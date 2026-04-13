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
  documentation.dev.enable = true;
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
  programs.nix-ld.libraries = with pkgs; [
    libcap
    openssl
    zlib
  ];
  nix = {
    gc.dates = "weekly";
    optimise = {
      automatic = true;
      dates = [ "03:45" ];
    };
  };
  environment = {
    localBinInPath = true;
    systemPackages = with pkgs; [
      libcap
      man-pages
      man-pages-posix
      (writeShellScriptBin "rb" ''
        (cd $HOME/.nix-config && git add --all && sudo nixos-rebuild switch --flake .)
      '')
    ];
  };
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
