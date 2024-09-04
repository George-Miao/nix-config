{flake, ...}: {
  imports = [flake.self.darwinModules.default];

  networking.hostName = "Fuji";

  nixpkgs.hostPlatform = "aarch64-darwin";

  services.nix-daemon.enable = true;
  services.nix-daemon.logFile = "/var/log/nix-daemon.log";

  system.stateVersion = 4;

  nix.linux-builder.enable = true;
}
