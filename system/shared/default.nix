{
  flake,
  pkgs,
  specialArgs,
  ...
}: {
  imports = [
    ./nix.nix
    ./user.nix
  ];

  home-manager.extraSpecialArgs = {
    inherit (specialArgs) consts tools secrets;
  };

  nixpkgs = {
    config.allowUnfree = true;

    overlays = with flake.inputs; [
      rust-overlay.overlays.default
    ];
  };
}
