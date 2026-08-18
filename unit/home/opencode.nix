{ config, ... }:
{
  programs.opencode = {
    enable = true;
    context = config.agent.context;
  };
}
