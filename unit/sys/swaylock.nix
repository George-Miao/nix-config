{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.swaylock-effects ];
  security.pam.services.swaylock = { };
}
