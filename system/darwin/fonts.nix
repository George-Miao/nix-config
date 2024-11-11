{pkgs, ...}: {
  fonts.packages = import ../shared/font-pkgs.nix {inherit pkgs;};
}
