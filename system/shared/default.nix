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
      # Home Manager still needs GTK 2 to build its input-method cache.
      problems.handlers."gtk+".broken = "warn";
    };

    overlays = with inputs; [
      rust-overlay.overlays.default
      ts3-noweb.overlays.default
    ];
  };
}
