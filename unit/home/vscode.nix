{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = (pkgs.vscode.override {isInsiders = true;}).overrideAttrs (f: oldAttrs: {
      src = builtins.fetchTarball {
        url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
        sha256 = "0yvdsg7prl37q9jalj1rb61pmympak9r69d9c9q6dv42wpdkjba9";
      };
      version = "latest";
      buildInputs = oldAttrs.buildInputs ++ [pkgs.krb5];
    });
  };
}
