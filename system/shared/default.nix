{ pkgs, ... }: {
  imports = [
    ./nix.nix
    ./user.nix
  ];

  nixpkgs.config.allowUnfree = true;
  services.xserver.libinput.enable = true;
}

