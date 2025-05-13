{...}: {
  services.syncthing = {
    enable = true;
    extraOptions = [
      "--no-browser"
    ];
  };
}
