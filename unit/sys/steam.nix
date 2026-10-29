{ pkgs, ... }:
{
  programs = {
    steam = {
      enable = true;

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;

      # Select Steam-Play-None per game when old Unity cannot find container fonts.
      extraCompatPackages = [ pkgs.steam-play-none ];

      package = pkgs.steam.override {
        extraPkgs =
          pkgs: with pkgs; [
            mesa-demos
            bumblebee
            # Old Unity scans /usr/share/fonts without using fontconfig.
            wqy_microhei
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
