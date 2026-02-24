{ pkgs, ... }:
{
  users.users.pop.extraGroups = [ "adbusers" ];
  environment.systemPackages = with pkgs; [
    android-tools
  ];
}
