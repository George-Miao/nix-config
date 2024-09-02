{...}: {
  services.xserver = {
    enable = true;

    autoRepeatDelay = 200;
    autoRepeatInterval = 50;

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
