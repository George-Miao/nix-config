{
  pkgs,
  unit,
  secrets,
  consts,
  ...
}:
{
  imports = with unit.sys; [
    yubico
    netbird-client
  ];
  home-manager.backupFileExtension = "bkup";
  documentation.dev.enable = true;
  boot.initrd.systemd.dbus.enable = true;

  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        consts.ssh
      ];
    };
    pop = {
      extraGroups = [
        "wheel"
        "docker"
        "dialout"
        "tty"
      ];
      isNormalUser = true;
      password = secrets.user.password;
      openssh.authorizedKeys.keys = [
        consts.ssh
      ];
    };
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
      gcc
      libcap
      man-pages
      man-pages-posix
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
