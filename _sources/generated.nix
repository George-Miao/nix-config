# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  nordic-wallpaper = {
    pname = "nordic-wallpaper";
    version = "4451bb432fc855159ab77a2ee41a0d4b8f60555a";
    src = fetchFromGitHub {
      owner = "linuxdotexe";
      repo = "nordic-wallpapers";
      rev = "4451bb432fc855159ab77a2ee41a0d4b8f60555a";
      fetchSubmodules = false;
      sha256 = "sha256-rDlhp5bkFoHcIRq+SASk34nzcS9MJ63yR46/RBYL7AQ=";
    };
    date = "2024-10-02";
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
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/1db1071148a1efa3b7ad7592d64507ef52536a3e/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/1db1071148a1efa3b7ad7592d64507ef52536a3e/VSCode-darwin-universal.zip";
      sha256 = "sha256-0U1YlK0DT+GXeKILEBa0XyaOkYu7+abnNH2PX+RWwIE=";
    };
  };
  vscode-darwin-stable = {
    pname = "vscode-darwin-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/91fbdddc47bc9c09064bf7acf133d22631cbf083/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/91fbdddc47bc9c09064bf7acf133d22631cbf083/VSCode-darwin-universal.zip";
      sha256 = "sha256-ulTeW6ruX+YgMP3FpzasR3tG2b3irB1at667uP53jg4=";
    };
  };
  vscode-linux-insider = {
    pname = "vscode-linux-insider";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/1db1071148a1efa3b7ad7592d64507ef52536a3e/code-insider-x64-1736920421.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/1db1071148a1efa3b7ad7592d64507ef52536a3e/code-insider-x64-1736920421.tar.gz";
      sha256 = "sha256-ifYjNb/SR9Xf6Y4FqfdWgxr+d7GscuWpyjYL51KTBdU=";
    };
  };
  vscode-linux-stable = {
    pname = "vscode-linux-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/91fbdddc47bc9c09064bf7acf133d22631cbf083/code-stable-x64-1736453197.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/91fbdddc47bc9c09064bf7acf133d22631cbf083/code-stable-x64-1736453197.tar.gz";
      sha256 = "sha256-Tv8eYrmroBRzwyT7k+BaW46LTzTPq+Q/1AsNLQfoXoQ=";
    };
  };
}
