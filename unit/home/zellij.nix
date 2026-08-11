{ pkgs, ... }:
let
  source = pkgs.fetchFromGitHub {
    owner = "zellij-org";
    repo = "zellij";
    rev = "0e6e4404027a187f1399a43bf91bdbd13d9636e1";
    hash = "sha256-gQcqEq8hs66A3vVd7mUWJBSzPiU1ojvYi/VFdwK5jlo=";
  };
  zellijUnwrapped = pkgs.zellij-unwrapped.overrideAttrs (_: {
    # PR #5428 adds Kitty image protocol support before the next Zellij release.
    # TODO: Switch back to Nixpkgs' Zellij once a release containing PR #5428 is cut.
    version = "0.45.0";
    src = source;
    cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      src = source;
      hash = "sha256-GqRpkbRtyWrQNcdJZSWj6MwyNQ8dipbU1eeRoV6RXrg=";
    };
    postInstall = pkgs.lib.optionalString (pkgs.stdenv.buildPlatform.canExecute pkgs.stdenv.hostPlatform) ''
      installShellCompletion --cmd zellij \
        --bash <($out/bin/zellij setup --generate-completion bash) \
        --fish <($out/bin/zellij setup --generate-completion fish) \
        --zsh <($out/bin/zellij setup --generate-completion zsh)
    '';
  });
  zellij = pkgs.zellij.override { zellij-unwrapped = zellijUnwrapped; };
in
{
  _module.args.zellijPackage = zellij;

  home.packages = [ zellij ];

  xdg.configFile.zellij = {
    recursive = true;
    target = "zellij/config.kdl";
    text = builtins.readFile ./zellij.config.kdl;
  };
}
