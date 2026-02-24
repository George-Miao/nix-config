{ pkgs, ... }:
let
  xcharter = pkgs.stdenv.mkDerivation {
    pname = "XCharter";
    version = "1.26";

    src = pkgs.fetchzip {
      url = "https://mirrors.ctan.org/fonts/xcharter.zip";
      hash = "sha256-2PfPmG15Q+woBzZ7BSC/6aq566/4PM40w1766+miRgg=";
    };

    installPhase = ''
      runHook preInstall
      install -Dm644 -t $out/share/fonts/opentype/ opentype/*.otf
      runHook postInstall
    '';
  };
in
with pkgs;
[
  fira
  fira-sans
  fira-go
  alegreya
  alegreya-sans
  xcharter
  ubuntu-classic
  corefonts
  vista-fonts
  cascadia-code
  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-color-emoji
  source-han-sans
  source-han-serif
  liberation_ttf
  font-awesome
  powerline-fonts
  mplus-outline-fonts.githubRelease

  # Nerd Fonts
  nerd-fonts.noto
  nerd-fonts.caskaydia-cove
  nerd-fonts.caskaydia-mono
]
