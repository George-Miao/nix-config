{ ... }:
{
  nix = {
    settings = {
      download-buffer-size = 4294967296;
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
      dates = "weekly";
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };
}
