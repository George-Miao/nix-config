{ pkgs, ... }:
let
  rust = pkgs.rust-bin.selectLatestNightlyWith (
    toolchain:
    toolchain.default.override {
      extensions = [ "rust-src" ];
    }
  );
in
{
  home.packages = [
    rust
  ];
}
