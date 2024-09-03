{flake, ...}: let
  secrets = flake.self.secrets.yubico;
in {
  security.pam = {
    yubico = {
      enable = true;
      id = secrets.client_id;
    };
  };

  home-manager.users.${flake.config.user}.pam.yubico.authorizedYubiKeys.ids = secrets.yubikey_ids;
}
