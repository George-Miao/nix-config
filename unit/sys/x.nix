{ ... }: {
  services.xserver = {
    enable = true;

    desktopManager = { xterm.enable = false; };
    displayManager = { defaultSession = "none+i3"; };
    windowManager.i3 = { enable = true; };

    xkb = {
      layout = "us";
      options = "eurosign:e,caps:escape";
    };
  };
}
