{ config, ... }:
{
  virtualisation.virtualbox.host = {
    enable = true;
    # enableKvm = true;
    # addNetworkInterface = false;
  };
  users.extraGroups.vboxusers.members = [ "pop" ];
}
