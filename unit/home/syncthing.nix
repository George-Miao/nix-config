{ secrets, ... }:
{
  # Syncthing 2 does not create a default folder. Home Manager disables the browser.
  services.syncthing = {
    enable = true;
    settings = secrets.syncthing.settings;
    overrideFolders = false;
  };
}
