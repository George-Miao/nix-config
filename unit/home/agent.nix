{ lib, ... }:
{
  options.agent = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = {
      context = "Only say or write ASD-STE100 Simplified Technical English. Never add description or Co-Author in git commit. Only write very brief sentence of description when making PR.";
    };
    description = "Shared AI agent configuration.";
  };
}
