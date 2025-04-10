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
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/043f699013796cbeae7c8fe9abac9b9eb26b3c51/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/043f699013796cbeae7c8fe9abac9b9eb26b3c51/VSCode-darwin-universal.zip";
      sha256 = "sha256-QUELb55gUdJNLzIgE280qOIWo/CF2uECocnLeNqWrW4=";
    };
  };
  vscode-darwin-stable = {
    pname = "vscode-darwin-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/4949701c880d4bdb949e3c0e6b400288da7f474b/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/4949701c880d4bdb949e3c0e6b400288da7f474b/VSCode-darwin-universal.zip";
      sha256 = "sha256-gOt7jtVpT2oV73yc001uPl/fO1glcftehf70QUbfSn8=";
    };
  };
  vscode-linux-insider = {
    pname = "vscode-linux-insider";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/043f699013796cbeae7c8fe9abac9b9eb26b3c51/code-insider-x64-1744349856.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/043f699013796cbeae7c8fe9abac9b9eb26b3c51/code-insider-x64-1744349856.tar.gz";
      sha256 = "sha256-W76jUfk5sFOmtiQXKQEiJxv8pXh+hUvpZIZHxSerx5o=";
    };
  };
  vscode-linux-stable = {
    pname = "vscode-linux-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/4949701c880d4bdb949e3c0e6b400288da7f474b/code-stable-x64-1744249013.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/4949701c880d4bdb949e3c0e6b400288da7f474b/code-stable-x64-1744249013.tar.gz";
      sha256 = "sha256-i9srXOGQRf5kXU6VLHWoBYU8sAqOZB2UyDLZKOTh6T0=";
    };
  };
}
