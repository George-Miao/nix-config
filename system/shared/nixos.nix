{flake, ...}: {
  users.users.${flake.config.user} = {
    extraGroups = ["wheel"];
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
