{lib, ...}:
with lib; {
  config = {
    user = "pop";
  };

  options = {
    user = mkOption {
      type = types.str;
      description = "The default user name";
    };
  };
}
