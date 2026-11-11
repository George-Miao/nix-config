{ pkgs, ... }:
let
  rust = pkgs.rust-bin.selectLatestNightlyWith (
    toolchain:
    toolchain.default.override {
      extensions = [ "rust-src" ];
      # Zed builds development extensions for this target.
      targets = [ "wasm32-wasip2" ];
    }
  );
in
{
  home.packages = [
    rust
  ];
}
