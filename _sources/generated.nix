# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  nordic-wallpaper = {
    pname = "nordic-wallpaper";
    version = "1b0102fb3fc39d29bf9d1c5385b1c1ad873c7e54";
    src = fetchFromGitHub {
      owner = "linuxdotexe";
      repo = "nordic-wallpapers";
      rev = "1b0102fb3fc39d29bf9d1c5385b1c1ad873c7e54";
      fetchSubmodules = false;
      sha256 = "sha256-KDkTnEBdL/DQ7ZJ62t3vTAO3OwE69KDsQ5gSTWh84GM=";
    };
    date = "2025-02-10";
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
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/942d11fff1a3a4f0faa918b59803f699ec61b9b6/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/942d11fff1a3a4f0faa918b59803f699ec61b9b6/VSCode-darwin-universal.zip";
      sha256 = "sha256-UqTo0JPNRtfyqquzBMv5dTb6Tz76uGrPVkhNkR+48d8=";
    };
  };
  vscode-darwin-stable = {
    pname = "vscode-darwin-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/17baf841131aa23349f217ca7c570c76ee87b957/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/17baf841131aa23349f217ca7c570c76ee87b957/VSCode-darwin-universal.zip";
      sha256 = "sha256-az+qy5L643U5TXZ93Tn9nsSP+lGmEYBJ+z4lZNkvZIg=";
    };
  };
  vscode-linux-insider = {
    pname = "vscode-linux-insider";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/942d11fff1a3a4f0faa918b59803f699ec61b9b6/code-insider-x64-1744780792.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/942d11fff1a3a4f0faa918b59803f699ec61b9b6/code-insider-x64-1744780792.tar.gz";
      sha256 = "sha256-H/XNmJ7NlGfpL2TzWmyqiTIAIQXmHXOBfB3zRqA3cBA=";
    };
  };
  vscode-linux-stable = {
    pname = "vscode-linux-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/17baf841131aa23349f217ca7c570c76ee87b957/code-stable-x64-1744760498.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/17baf841131aa23349f217ca7c570c76ee87b957/code-stable-x64-1744760498.tar.gz";
      sha256 = "sha256-ZhmD2QGY3wL+WaIW3pCNwJXFvn8hgJ5v1MHR+sNCznA=";
    };
  };
}
