{ secrets, ... }:
{
  services.syncthing = {
    enable = true;
    settings = secrets.syncthing.settings;
    overrideFolders = false;
    extraOptions = [
      "--no-browser"
      "--no-default-folder"
    ];
  };
}
