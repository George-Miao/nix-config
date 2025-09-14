{...}: {
  services.gnome = {
    gnome-online-accounts.enable = true;
    gnome-keyring.enable = true;
    gcr-ssh-agent.enable = false;
  };
  programs.seahorse.enable = true;
}
