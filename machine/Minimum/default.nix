{
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
  ];

  networking = {
    hostName = "Minimum";
    useDHCP = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    htop
    neofetch
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  time.timeZone = "America/New_York";

  system.stateVersion = "24.05";
}
