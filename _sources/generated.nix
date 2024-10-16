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
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/c85acdad6b679973c79b01a38afa91448c705c1c/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/c85acdad6b679973c79b01a38afa91448c705c1c/VSCode-darwin-universal.zip";
      sha256 = "sha256-Lk8JpY5ttP3LT0XD3fnFlNhH5+lvAmVuzH3/Gpv3Fwg=";
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
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/c85acdad6b679973c79b01a38afa91448c705c1c/code-insider-x64-1729239221.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/c85acdad6b679973c79b01a38afa91448c705c1c/code-insider-x64-1729239221.tar.gz";
      sha256 = "sha256-VLIrBZtbOGNMUud1hevgeCjUV7WrfKLshs20RceWx88=";
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
