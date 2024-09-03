{
  flake,
  pkgs,
  ...
}: {
  imports = [
    ./nix.nix
    ./user.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;

    overlays = with flake.inputs; [
      rust-overlay.overlays.default
      deploy-rs.overlays.default
      (self: super: {deploy-rs = {inherit (pkgs) deploy-rs;};})
    ];
  };
}
