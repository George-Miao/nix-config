{...}: {
  nix = {
    settings.experimental-features = ["nix-command" "flakes" "repl-flake"];
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };
}
