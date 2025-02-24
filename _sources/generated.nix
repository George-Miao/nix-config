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
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/fa907e1b4967c7db216f988d9ae551c2d8e0edd5/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/fa907e1b4967c7db216f988d9ae551c2d8e0edd5/VSCode-darwin-universal.zip";
      sha256 = "sha256-PQY+MInV8b1QwoDZcozoufd/ERHZhBqR+vWjJC/MBhY=";
    };
  };
  vscode-darwin-stable = {
    pname = "vscode-darwin-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/e54c774e0add60467559eb0d1e229c6452cf8447/VSCode-darwin-universal.zip";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/e54c774e0add60467559eb0d1e229c6452cf8447/VSCode-darwin-universal.zip";
      sha256 = "sha256-41Wi4wqrDm6apMW/4T3CdOLUI+Zfhz5NKw2V3tfONQY=";
    };
  };
  vscode-linux-insider = {
    pname = "vscode-linux-insider";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/fa907e1b4967c7db216f988d9ae551c2d8e0edd5/code-insider-x64-1740393393.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/insider/fa907e1b4967c7db216f988d9ae551c2d8e0edd5/code-insider-x64-1740393393.tar.gz";
      sha256 = "sha256-S/XSai4pZwEhQOKmSjShbWxa3Rh4f/gTlqbnNXpEd60=";
    };
  };
  vscode-linux-stable = {
    pname = "vscode-linux-stable";
    version = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/e54c774e0add60467559eb0d1e229c6452cf8447/code-stable-x64-1739405584.tar.gz";
    src = fetchTarball {
      url = "https://vscode.download.prss.microsoft.com/dbazure/download/stable/e54c774e0add60467559eb0d1e229c6452cf8447/code-stable-x64-1739405584.tar.gz";
      sha256 = "sha256-aDMJoQVhVnutY56GmufJcg9EPmUEO/4nY4cp3OMvxd8=";
    };
  };
}
