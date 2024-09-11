{...}: {
  services.gnome = {
    gnome-online-accounts.enable = true;
    gnome-keyring.enable = true;
  };
  programs.seahorse.enable = true;
}
