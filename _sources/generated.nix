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
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/92b713f613bd24c7b271eea6cedc45181207f179/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/92b713f613bd24c7b271eea6cedc45181207f179/VSCode-darwin-universal.zip";
      sha256 = "sha256-7+0quCEIA8pef4Igi+8JJBhKQsiQQB1wHCOTXKuRnks=";
    };
  };
  vscode-darwin-stable = {
    pname = "vscode-darwin-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/65edc4939843c90c34d61f4ce11704f09d3e5cb6/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/65edc4939843c90c34d61f4ce11704f09d3e5cb6/VSCode-darwin-universal.zip";
      sha256 = "sha256-iJ1mB1eECycpSvoyuOKJXY7oYjrEkMjELkDNXDJlfRw=";
    };
  };
  vscode-linux-insider = {
    pname = "vscode-linux-insider";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/92b713f613bd24c7b271eea6cedc45181207f179/code-insider-x64-1730929370.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/92b713f613bd24c7b271eea6cedc45181207f179/code-insider-x64-1730929370.tar.gz";
      sha256 = "sha256-FFXx/gIlqkbXSl1gcAkS8WPyylDkvH53vW6GkCn7ugA=";
    };
  };
  vscode-linux-stable = {
    pname = "vscode-linux-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/65edc4939843c90c34d61f4ce11704f09d3e5cb6/code-stable-x64-1730354220.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/65edc4939843c90c34d61f4ce11704f09d3e5cb6/code-stable-x64-1730354220.tar.gz";
      sha256 = "sha256-tPFFJ7zjFTBzyyNNZ+t1IfWkTd4twrJBsbuMl9d6LzE=";
    };
  };
}
