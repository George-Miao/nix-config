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
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/d78a74bcdfad14d5d3b1b782f87255d802b57511/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/d78a74bcdfad14d5d3b1b782f87255d802b57511/VSCode-darwin-universal.zip";
      sha256 = "sha256-brR+PNFU1jqQopmY7BwVZKuoMbzlmecFUMpa1Yn5Sww=";
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
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/d78a74bcdfad14d5d3b1b782f87255d802b57511/code-insider-x64-1727877344.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/d78a74bcdfad14d5d3b1b782f87255d802b57511/code-insider-x64-1727877344.tar.gz";
      sha256 = "sha256-oMy7a/YvgZMAxav6m0Wg/D3M9EpwV3s7IuicheGz804=";
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
