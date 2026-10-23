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
      # Temporary backport of google/mozc@29c082a for Qt uic.
      (_: prev: {
        mozc = prev.mozc.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [
            (prev.fetchpatch {
              url = "https://github.com/google/mozc/commit/29c082a64b577b661694148760a2ae19817beb57.patch";
              hash = "sha256-TcuMPd3E4ZPhU4tmeVD7OMY4tWFJGjiiSXZSh3gn384=";
            })
          ];
        });
      })
    ];
  };
}
