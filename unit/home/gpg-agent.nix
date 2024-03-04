{...}: {
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    pinentryFlavor = "gtk2";
  };
}
