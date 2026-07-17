{ inputs, secrets, ... }:
{
  nixpkgs.config = {
    problems.handlers = {
      nvidia-x11.broken = "warn"; # or "ignore"
    };
  };

  nix = {
    registry.nixpkgs.flake = inputs.nixpkgs;
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
      substituters = [
        "https://zed.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
      ];
      access-tokens = "github.com=${secrets.github.oauth_token}";
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };
}
