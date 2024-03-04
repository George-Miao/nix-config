{
  flake,
  pkgs,
  ...
}: {
  imports = [./nix.nix ./user.nix];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [flake.inputs.rust-overlay.overlays.default];
  };
}
