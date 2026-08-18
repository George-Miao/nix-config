{ config, pkgs, ... }:
{
  home.packages = [ pkgs.github-copilot-cli ];

  home.file.".copilot/copilot-instructions.md".text = config.agent.context;
}
