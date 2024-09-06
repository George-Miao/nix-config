# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  nordic-wallpaper = {
    pname = "nordic-wallpaper";
    version = "78b242f58faf31541ba4d76926849253b4d2e979";
    src = fetchFromGitHub {
      owner = "linuxdotexe";
      repo = "nordic-wallpapers";
      rev = "78b242f58faf31541ba4d76926849253b4d2e979";
      fetchSubmodules = false;
      sha256 = "sha256-gayN5wC3sbcixqdx2vaZiGT/aKyUbVtBouvrYkZfgcU=";
    };
    date = "2024-07-15";
  };
  pop-wallpaper = {
    pname = "pop-wallpaper";
    version = "84356f";
    src = fetchFromGitHub {
      owner = "George-Miao";
      repo = "wallpaper";
      rev = "84356f";
      fetchSubmodules = false;
      sha256 = "sha256-o5LwZYSk/pAdr3Zr1JxjLl6Ggp/LB4VFkjgKlBbEo44=";
    };
  };
  vscode-darwin-insider = {
    pname = "vscode-darwin-insider";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/a162831c17ad0d675f1f0d5c3f374fd1514f04b5/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/a162831c17ad0d675f1f0d5c3f374fd1514f04b5/VSCode-darwin-universal.zip";
      sha256 = "sha256-SGo6QywqMB4IiJVrW8sr2E93r3j+Ie565I/5Hx0NQ/c=";
    };
  };
  vscode-darwin-stable = {
    pname = "vscode-darwin-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/4849ca9bdf9666755eb463db297b69e5385090e3/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/4849ca9bdf9666755eb463db297b69e5385090e3/VSCode-darwin-universal.zip";
      sha256 = "sha256-bSscF7cPYC02YsNncxTvI47YsnnYUgof4PgdrjFfbjc=";
    };
  };
  vscode-linux-insider = {
    pname = "vscode-linux-insider";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/a162831c17ad0d675f1f0d5c3f374fd1514f04b5/code-insider-x64-1725629691.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/a162831c17ad0d675f1f0d5c3f374fd1514f04b5/code-insider-x64-1725629691.tar.gz";
      sha256 = "sha256-dZjLPoCtryKe+Z4LzkFrWY+ZaIsWE4HvKp3EUXFJgmc=";
    };
  };
  vscode-linux-stable = {
    pname = "vscode-linux-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/4849ca9bdf9666755eb463db297b69e5385090e3/code-stable-x64-1725457701.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/4849ca9bdf9666755eb463db297b69e5385090e3/code-stable-x64-1725457701.tar.gz";
      sha256 = "sha256-ur4npaY2lPRQjVxCgbtMkVXSxmCyov50jUWS5Lq/Ir0=";
    };
  };
}
