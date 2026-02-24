{ pkgs, ... }:
{
  programs = {
    steam = {
      enable = true;

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;

      package = pkgs.steam.override {
        extraPkgs =
          pkgs: with pkgs; [
            mesa-demos
            bumblebee
          ];
      };
    };

    gamescope = {
      enable = true;
      capSysNice = true;
    };

    gamemode.enable = true;
    # nix-ld.enable = true;
  };
}
