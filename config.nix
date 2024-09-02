{lib, ...}:
with lib; {
  config = {
    user = "pop";
    wayland_restart_delay = 1;
  };

  options = {
    user = mkOption {
      type = types.str;
      description = "The default user name";
    };

    wayland_restart_delay = mkOption {
      type = types.number;
      description = "Restart delay for services after wayland compositor quit";
    };
  };
}
