{ config, ... }:
{
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };
  users.users."pop".extraGroups = [ "docker" ];
}
