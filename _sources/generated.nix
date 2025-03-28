# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  nordic-wallpaper = {
    pname = "nordic-wallpaper";
    version = "1b0102fb3fc39d29bf9d1c5385b1c1ad873c7e54";
    src = fetchFromGitHub {
      owner = "linuxdotexe";
      repo = "nordic-wallpapers";
      rev = "1b0102fb3fc39d29bf9d1c5385b1c1ad873c7e54";
      fetchSubmodules = false;
      sha256 = "sha256-KDkTnEBdL/DQ7ZJ62t3vTAO3OwE69KDsQ5gSTWh84GM=";
    };
    date = "2025-02-10";
  };
  pop-wallpaper = {
    pname = "pop-wallpaper";
    version = "8537fe";
    src = fetchFromGitHub {
      owner = "George-Miao";
      repo = "wallpaper";
      rev = "8537fe";
      fetchSubmodules = false;
      sha256 = "sha256-23C4CYqBeYniOyS1Tm4INQOpycvnSJ+ivx2jeNb/54g=";
    };
  };
  vscode-darwin-insider = {
    pname = "vscode-darwin-insider";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/99c9c6c8eb0aef3fce659b0fac1ff3130c4e34a4/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/99c9c6c8eb0aef3fce659b0fac1ff3130c4e34a4/VSCode-darwin-universal.zip";
      sha256 = "sha256-RTp0gvDsls9UQTruGA76YRWRv8waUZFCDt0KhPTZFT0=";
    };
  };
  vscode-darwin-stable = {
    pname = "vscode-darwin-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/ddc367ed5c8936efe395cffeec279b04ffd7db78/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/ddc367ed5c8936efe395cffeec279b04ffd7db78/VSCode-darwin-universal.zip";
      sha256 = "sha256-4IuVHp5AAi7J+iBa9lpJs7WggHRTljabAGgq45sO42Q=";
    };
  };
  vscode-linux-insider = {
    pname = "vscode-linux-insider";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/99c9c6c8eb0aef3fce659b0fac1ff3130c4e34a4/code-insider-x64-1743198452.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/99c9c6c8eb0aef3fce659b0fac1ff3130c4e34a4/code-insider-x64-1743198452.tar.gz";
      sha256 = "sha256-mD71mDJN1Xnp8itNV0Ke69mfha5Cx72I9gXbO2dwlHQ=";
    };
  };
  vscode-linux-stable = {
    pname = "vscode-linux-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/ddc367ed5c8936efe395cffeec279b04ffd7db78/code-stable-x64-1741787903.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/ddc367ed5c8936efe395cffeec279b04ffd7db78/code-stable-x64-1741787903.tar.gz";
      sha256 = "sha256-GhOdubnst0twZAcsScvypBDWyKjcJET0MgWK9Wc9TOo=";
    };
  };
}
