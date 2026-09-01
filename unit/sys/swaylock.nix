{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.swaylock ];
  security.pam.services.swaylock = { };
}
