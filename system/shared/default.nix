{ flake, pkgs, ... }: {
  imports = [
    ./nix.nix
    ./user.nix
  ];

  nixpkgs.overlays = [ flake.inputs.rust-overlay.overlays.default ];
  nixpkgs.config.allowUnfree = true;
}

