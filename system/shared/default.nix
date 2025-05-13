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
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-29.4.6"
      ];
    };

    overlays = with flake.inputs; [
      rust-overlay.overlays.default
    ];
  };
}
