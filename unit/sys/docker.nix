{ flake, ... }:
{
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };
  users.users."${flake.config.user}".extraGroups = [ "docker" ];
}
