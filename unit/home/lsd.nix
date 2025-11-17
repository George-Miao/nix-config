{...}: {
  programs.lsd = {
    enable = true;
    settings = {
      sorting = {
        column = "time";
        reverse = true;
      };
    };
  };
}
