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
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/21a129e8d0fbdfabcae2444b04a0e4c3912c6fe1/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/21a129e8d0fbdfabcae2444b04a0e4c3912c6fe1/VSCode-darwin-universal.zip";
      sha256 = "sha256-zP4u1C23fS4NEopXEF0lq73kZtn7I1Bv2dkbacyMfsI=";
    };
  };
  vscode-darwin-stable = {
    pname = "vscode-darwin-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/138f619c86f1199955d53b4166bef66ef252935c/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/138f619c86f1199955d53b4166bef66ef252935c/VSCode-darwin-universal.zip";
      sha256 = "sha256-++JvHBT5McOlAN/G0Y9tDHJwKnA844OfvWVVF9HXlGM=";
    };
  };
  vscode-linux-insider = {
    pname = "vscode-linux-insider";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/21a129e8d0fbdfabcae2444b04a0e4c3912c6fe1/code-insider-x64-1734096209.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/21a129e8d0fbdfabcae2444b04a0e4c3912c6fe1/code-insider-x64-1734096209.tar.gz";
      sha256 = "sha256-9+jdeD/pIEcNS3jiqewlmh1icmnREI3VeALKPRdadPU=";
    };
  };
  vscode-linux-stable = {
    pname = "vscode-linux-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/138f619c86f1199955d53b4166bef66ef252935c/code-stable-x64-1733887021.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/138f619c86f1199955d53b4166bef66ef252935c/code-stable-x64-1733887021.tar.gz";
      sha256 = "sha256-Jq2PpPtzRpX9GqhG8O/klKK3D0N1hyC+VQLYCAbz9lM=";
    };
  };
}
