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
    version = "6c471f";
    src = fetchFromGitHub {
      owner = "George-Miao";
      repo = "wallpaper";
      rev = "6c471f";
      fetchSubmodules = false;
      sha256 = "sha256-D/f9ZhiIW5Aqyp7mQ2sVuwCL7SxvWHcfvB3ZIB2paII=";
    };
  };
  vscode-darwin-insider = {
    pname = "vscode-darwin-insider";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/8d1bb84a183d8a4eb74c12ec11c0c5080a548547/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/8d1bb84a183d8a4eb74c12ec11c0c5080a548547/VSCode-darwin-universal.zip";
      sha256 = "sha256-WzjuTcw1EIozN1O2Le29eX0lDz3HNONg0ymbxuMFoGM=";
    };
  };
  vscode-darwin-stable = {
    pname = "vscode-darwin-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/38c31bc77e0dd6ae88a4e9cc93428cc27a56ba40/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/38c31bc77e0dd6ae88a4e9cc93428cc27a56ba40/VSCode-darwin-universal.zip";
      sha256 = "sha256-kbh7P4BD3sL4TMiRhsvcGKyezmbT3tqsDi3tV6iC/UM=";
    };
  };
  vscode-linux-insider = {
    pname = "vscode-linux-insider";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/8d1bb84a183d8a4eb74c12ec11c0c5080a548547/code-insider-x64-1726724734.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/8d1bb84a183d8a4eb74c12ec11c0c5080a548547/code-insider-x64-1726724734.tar.gz";
      sha256 = "sha256-Pa10Y/CfoEslJj3mpsPztkzqnXnh+MlM6KXsKFat12E=";
    };
  };
  vscode-linux-stable = {
    pname = "vscode-linux-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/38c31bc77e0dd6ae88a4e9cc93428cc27a56ba40/code-stable-x64-1726078107.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/38c31bc77e0dd6ae88a4e9cc93428cc27a56ba40/code-stable-x64-1726078107.tar.gz";
      sha256 = "sha256-QO9+8r+wLXqByfdRaunEaHv8f17srDSZuUpOiYjquvw=";
    };
  };
}
