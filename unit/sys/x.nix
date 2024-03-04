{pkgs, ...}: {
  services.xserver = {
    enable = true;

    libinput.enable = true;

    desktopManager = {
      xterm.enable = false;
      runXdgAutostartIfNone = true;
    };

    xkb = {
      layout = "us";
      options = "eurosign:e,caps:escape";
    };
  };
}
