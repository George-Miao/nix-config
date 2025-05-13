{pkgs, ...}: {
  services.atd.enable = true;
  environment.systemPackages = [
    pkgs.at
  ];
}
