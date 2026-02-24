{ pkgs, ... }:
{
  services.globalprotect = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    globalprotect-openconnect
  ];
}
