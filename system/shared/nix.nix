{ ... }:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "pop"
        "root"
        "wheel"
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };
}
