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
      substituters = [
        "https://aseipp-nix-cache.global.ssl.fastly.net"
        "https://zed.cachix.org"
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };
}
