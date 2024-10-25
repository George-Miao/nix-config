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
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/59260b311c71846b730992d76c6358b43646eea8/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/59260b311c71846b730992d76c6358b43646eea8/VSCode-darwin-universal.zip";
      sha256 = "sha256-ML6m36qUbwEjxZ3cKC9PNhOSr/QLK2uAfyTpM9I23EY=";
    };
  };
  vscode-darwin-stable = {
    pname = "vscode-darwin-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/384ff7382de624fb94dbaf6da11977bba1ecd427/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/384ff7382de624fb94dbaf6da11977bba1ecd427/VSCode-darwin-universal.zip";
      sha256 = "sha256-BAcQ0b+462t3BrvFkPz3J75ZvS/DA7dhVF3lav48YkM=";
    };
  };
  vscode-linux-insider = {
    pname = "vscode-linux-insider";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/59260b311c71846b730992d76c6358b43646eea8/code-insider-x64-1729815977.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/59260b311c71846b730992d76c6358b43646eea8/code-insider-x64-1729815977.tar.gz";
      sha256 = "sha256-3Aw7sPaXycyzAwKgEOapmKImq4T9ztWY0fB5U+PLgBc=";
    };
  };
  vscode-linux-stable = {
    pname = "vscode-linux-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/384ff7382de624fb94dbaf6da11977bba1ecd427/code-stable-x64-1728492644.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/384ff7382de624fb94dbaf6da11977bba1ecd427/code-stable-x64-1728492644.tar.gz";
      sha256 = "sha256-E5u/Cokz6i4lqU/EEttdvMkc4qMTOEqinEZLQ/jwz4A=";
    };
  };
}
