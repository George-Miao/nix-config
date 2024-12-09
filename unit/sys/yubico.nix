{
  flake,
  secrets,
  ...
}: {
  security.pam = {
    yubico = {
      enable = true;
      id = secrets.yubico.client_id;
    };
  };

  services.pcscd.enable = true;

  home-manager.users.${flake.config.user}.pam.yubico.authorizedYubiKeys.ids = secrets.yubico.yubikey_ids;
}
