{flake, ...}: let
  darwin = flake.self.darwinModules.default;
in {
  imports = [
    darwin
  ];

  networking.hostName = "Fuji";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  services.nix-daemon.enable = true;
  services.nix-daemon.logFile = "/var/log/nix-daemon.log";

  system.stateVersion = 4;
}
