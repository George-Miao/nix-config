{flake, ...}: {
  imports = with flake.self.unit.sys; [
    flake.self.darwinModules.default
    # (tailscale {autoStart = true;})
  ];

  networking.hostName = "Marcy";

  nixpkgs.hostPlatform = "aarch64-darwin";

  services.nix-daemon.enable = true;
  services.nix-daemon.logFile = "/var/log/nix-daemon.log";

  system.stateVersion = 4;

  nix.linux-builder.enable = true;

  system.defaults.NSGlobalDomain."com.apple.trackpad.scaling" = 1.5;
  system.keyboard = {
    enableKeyMapping = true;
    # Swap command and ctrl, for keyboard with CapsLock pre-mapped to Ctrl
    userKeyMapping = [
      {
        HIDKeyboardModifierMappingSrc = 30064771296;
        HIDKeyboardModifierMappingDst = 30064771299;
      }
      {
        HIDKeyboardModifierMappingSrc = 30064771299;
        HIDKeyboardModifierMappingDst = 30064771296;
      }
    ];
  };
}
