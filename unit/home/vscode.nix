with builtins; let
  mapAttr = f: list: listToAttrs (map f list);
in
  mapAttr (
    os: {
      name = os;
      value = mapAttr (build: {
        name = build;
        value = {
          pkgs,
          tools,
          ...
        }: let
          generated = tools.generate pkgs;
        in {
          programs.vscode = {
            enable = true;
            package = (pkgs.vscode.override {isInsiders = build == "insider";}).overrideAttrs (f: oldAttrs: {
              inherit (oldAttrs) buildInputs;
              src = generated."vscode-${os}-${build}".src;
              version = "latest";
            });
          };
        };
      }) ["stable" "insider"];
    }
  ) ["darwin" "linux"]
