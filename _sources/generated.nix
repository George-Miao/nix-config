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
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/3551cb01fa6f3a838e2d160df704cc3debfb9896/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/3551cb01fa6f3a838e2d160df704cc3debfb9896/VSCode-darwin-universal.zip";
      sha256 = "sha256-3aYaWD/UPjCpd7CvEMd/u/ji/Bwff4JG3/HWlgUEktY=";
    };
  };
  vscode-darwin-stable = {
    pname = "vscode-darwin-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/912bb683695358a54ae0c670461738984cbb5b95/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/912bb683695358a54ae0c670461738984cbb5b95/VSCode-darwin-universal.zip";
      sha256 = "sha256-CHKUyx1Q+gSiNv1BBvKTmMi9Qmw8SZOJOL4JI9tHvJU=";
    };
  };
  vscode-linux-insider = {
    pname = "vscode-linux-insider";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/3551cb01fa6f3a838e2d160df704cc3debfb9896/code-insider-x64-1730267197.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/3551cb01fa6f3a838e2d160df704cc3debfb9896/code-insider-x64-1730267197.tar.gz";
      sha256 = "sha256-t1l6JQmRDPsp5kPwVswAAZCTdG9ou55IbGjMrHkJRyY=";
    };
  };
  vscode-linux-stable = {
    pname = "vscode-linux-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/912bb683695358a54ae0c670461738984cbb5b95/code-stable-x64-1730152418.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/912bb683695358a54ae0c670461738984cbb5b95/code-stable-x64-1730152418.tar.gz";
      sha256 = "sha256-sWfDX+oJTEVaMGVGPpwWNFZWM8RivNcgHvNKEyUZfXw=";
    };
  };
}
