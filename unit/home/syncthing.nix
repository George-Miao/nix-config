{secrets, ...}: {
  services.syncthing = {
    enable = true;
    passwordFile = builtins.toFile "syncthing_password" secrets.syncthing.password;
    settings = {
      gui.user = "admin";
    };
    extraOptions = [
      "--no-browser"
    ];
  };
}
