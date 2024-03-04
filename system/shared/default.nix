{ pkgs, ... }: {
  imports = [
    ./nix.nix
    ./user.nix
  ];

  nixpkgs.config.allowUnfree = true;
}

