{
  lib,
  pkgs,
  ...
}: let
  caprover = pkgs.buildNpmPackage (finalAttrs: {
    pname = "caprover-cli";
    version = "2.3.1";

    src = pkgs.fetchFromGitHub {
      "owner" = "caprover";
      "repo" = "caprover-cli";
      "rev" = "66a3be524f2bc2e01fc9013a11ab183075cad7aa";
      "hash" = "sha256-6YNllhoVccZe84dl+foSavIeDXSKPaHm5oAferB8hSQ=";
    };

    npmDepsHash = "sha256-68vOWIM1KuEHvWLbwy11BBMGcrwtuwxkQqVBAiyoIVo=";

    # The prepack script runs the build script, which we'd rather do in the build phase.
    npmPackFlags = ["--ignore-scripts"];

    NODE_OPTIONS = "--openssl-legacy-provider";

    meta = {
      description = "Command Line Interface for https://github.com/caprover/caprover";
      homepage = "https://caprover.com/";
      license = lib.licenses.asl20;
      maintainers = [];
    };
  });
in {
  home.packages = [caprover];
}
