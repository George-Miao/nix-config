{ pkgs, ... }:
{
  home.packages = [ pkgs.github-copilot-cli ];

  home.file.".copilot/copilot-instructions.md".text =
    "Only report to me in ASD-STE100 Simplified Technical English.";
}
