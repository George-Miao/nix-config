{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = (pkgs.vscode.override {isInsiders = true;}).overrideAttrs (f: oldAttrs: {
      src = builtins.fetchTarball {
        url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
        sha256 = "171m66phx7li60qw9jch7kq9dylpw44sn9wvjj0p9248dxxajs21";
      };
      version = "latest";
      buildInputs = oldAttrs.buildInputs ++ [pkgs.krb5];
    });
  };
}
