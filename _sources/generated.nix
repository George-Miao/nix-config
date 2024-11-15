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
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/28f7008e9b2799e3004c48c26fff3d02ec8f13d8/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/28f7008e9b2799e3004c48c26fff3d02ec8f13d8/VSCode-darwin-universal.zip";
      sha256 = "sha256-ZdART7oXFpqO9KFypRTOupDDaSFORqSCSqC7sz8XBNk=";
    };
  };
  vscode-darwin-stable = {
    pname = "vscode-darwin-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/f1a4fb101478ce6ec82fe9627c43efbf9e98c813/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/f1a4fb101478ce6ec82fe9627c43efbf9e98c813/VSCode-darwin-universal.zip";
      sha256 = "sha256-qnSuhv6HUs1uMDvmuMJortkac5CEB21UYhIJd+EV/P8=";
    };
  };
  vscode-linux-insider = {
    pname = "vscode-linux-insider";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/28f7008e9b2799e3004c48c26fff3d02ec8f13d8/code-insider-x64-1731649632.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/28f7008e9b2799e3004c48c26fff3d02ec8f13d8/code-insider-x64-1731649632.tar.gz";
      sha256 = "sha256-jQ6zP1dcVsQbq5x41FT3J4qUAAVBj4EtY6/Zw9f1AqI=";
    };
  };
  vscode-linux-stable = {
    pname = "vscode-linux-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/f1a4fb101478ce6ec82fe9627c43efbf9e98c813/code-stable-x64-1731511985.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/f1a4fb101478ce6ec82fe9627c43efbf9e98c813/code-stable-x64-1731511985.tar.gz";
      sha256 = "sha256-0L4TjuSvVUZKO2gBtp1KK0+8lIADXUNNXYbU8QR5PMk=";
    };
  };
}
