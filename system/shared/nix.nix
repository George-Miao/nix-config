{...}: {
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    optimise = {
      automatic = true;
      dates = ["03:45"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
