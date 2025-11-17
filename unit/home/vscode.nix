with builtins;
let
  mapAttr = f: list: listToAttrs (map f list);
in
mapAttr
  (os: {
    name = os;
    value =
      mapAttr
        (build: {
          name = build;
          value =
            {
              pkgs,
              tools,
              ...
            }:
            {
              programs.vscode = {
                enable = true;
                package =
                  (pkgs.vscode.override {
                    isInsiders = build == "insider";
                    useVSCodeRipgrep = false;
                  }).overrideAttrs
                    (
                      f: oldAttrs: {
                        inherit (oldAttrs) buildInputs;
                        src = (tools.generate pkgs)."vscode-${os}-${build}".src;
                        version = "latest";
                      }
                    );
              };
            };
        })
        [
          "stable"
          "insider"
        ];
  })
  [
    "darwin"
    "linux"
  ]
