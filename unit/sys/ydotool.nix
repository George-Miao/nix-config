{ config, ... }:
{
  programs.ydotool.enable = true;
  users.users.pop.extraGroups = [ config.programs.ydotool.group ];
}
