{
  lib,
  pkgs,
  ...
}:
let
  local = lib.mapAttrs (name: _: ../../skills/${name}) (
    lib.filterAttrs (_: type: type == "directory") (builtins.readDir ../../skills)
  );
  remote = lib.mapAttrs (_: skill: "${skill}") (
    lib.mergeAttrsList (with pkgs.skills; [ mattpocock.skills ])
  );
  skills = remote // local;
  skillsDirectory = pkgs.linkFarm "agent-skills" (
    lib.mapAttrsToList (name: path: {
      inherit name path;
    }) skills
  );
in
{
  programs.claude-code.skills = skills;
  programs.codex.skills = skills;
  programs.opencode.skills = skills;

  home.file.".copilot/skills" = {
    source = "${skillsDirectory}";
    recursive = true;
  };

  home.file.".omp/agent/skills" = {
    source = "${skillsDirectory}";
    recursive = true;
  };
}
