{ config, pkgs, ... }:
let
  version = "1.40.1";
  source = pkgs.fetchFromGitHub {
    owner = "777genius";
    repo = "claude-notifications-go";
    rev = "74b9fba35169e7289aa3d644fb7cace26fa2e52f";
    hash = "sha256-XzbW374Kn8WvJQwc+T6OkogybhZvB7/d9qhVxPrZUAY=";
  };
  binary =
    if pkgs.stdenv.hostPlatform.isDarwin then
      pkgs.fetchurl {
        url = "https://github.com/777genius/claude-notifications-go/releases/download/v${version}/claude-notifications-darwin-arm64";
        hash = "sha256-gV9TgNfTzIDwNH/n80d+8Stm+0tyDWp8G23VdZreFSg=";
      }
    else if pkgs.stdenv.hostPlatform.isLinux then
      pkgs.fetchurl {
        url = "https://github.com/777genius/claude-notifications-go/releases/download/v${version}/claude-notifications-linux-amd64";
        hash = "sha256-3pzb/KBxv/ceKDIDm6k3GEQcfjKMUYmQFmderWlEpN4=";
      }
    else
      throw "claude-notifications-go is unsupported on ${pkgs.stdenv.hostPlatform.system}";
  plugin = pkgs.runCommand "claude-notifications-go-${version}" { } ''
    cp -R ${source} "$out"
    chmod -R u+w "$out"
    install -Dm755 ${binary} "$out/bin/claude-notifications"
  '';
in
{
  programs.claude-code = {
    enable = true;
    plugins.claude-notifications-go = plugin;
    context = config.agent.context;
    settings = {
      model = "claude-opus-4-8";
      theme = "auto";
    };
  };

  home.file.".claude/claude-notifications-go/config.json".source = "${plugin}/config/config.json";
}
