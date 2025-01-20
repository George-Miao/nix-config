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
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/3d0aeb47a2ecfde9ff5141470b30c36d41c321d9/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/3d0aeb47a2ecfde9ff5141470b30c36d41c321d9/VSCode-darwin-universal.zip";
      sha256 = "sha256-mX9ZJqixdFOVg5j6VNGP5yl7jtMcuacqoZYbTPACbMI=";
    };
  };
  vscode-darwin-stable = {
    pname = "vscode-darwin-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/cd4ee3b1c348a13bafd8f9ad8060705f6d4b9cba/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/cd4ee3b1c348a13bafd8f9ad8060705f6d4b9cba/VSCode-darwin-universal.zip";
      sha256 = "sha256-NXx62PDjvQhWaxr0fGf1kwCU0UQnO3IW6rkkwbl0wJo=";
    };
  };
  vscode-linux-insider = {
    pname = "vscode-linux-insider";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/3d0aeb47a2ecfde9ff5141470b30c36d41c321d9/code-insider-x64-1737352333.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/3d0aeb47a2ecfde9ff5141470b30c36d41c321d9/code-insider-x64-1737352333.tar.gz";
      sha256 = "sha256-X3GVV0nUGqaGA4HO7JZIN/XtoQwNr4ymf+w6QdNWhb0=";
    };
  };
  vscode-linux-stable = {
    pname = "vscode-linux-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/cd4ee3b1c348a13bafd8f9ad8060705f6d4b9cba/code-stable-x64-1736989961.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/cd4ee3b1c348a13bafd8f9ad8060705f6d4b9cba/code-stable-x64-1736989961.tar.gz";
      sha256 = "sha256-H8Cc6+GC+ZlRyvdWfzD+vkfEsfKErRp5LO5as+Vdu/k=";
    };
  };
}
