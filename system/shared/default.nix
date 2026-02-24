{
  inputs,
  ...
}:
{
  imports = [
    ./nix.nix
    ./user.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      nvidia.acceptLicense = true;
      allowInsecurePredicate = _: true;
    };

    overlays = with inputs; [
      rust-overlay.overlays.default
    ];
  };
}
