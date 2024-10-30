{secrets, ...}: {
  home.file.cargo_config = {
    target = ".cargo/config.toml";
    text = ''
      [build]
      target-dir = "/tmp/rust-target"
    '';
  };

  home.file.cargo_credential = {
    target = ".cargo/credentials.toml";
    text = ''
      [registry]
      token = "${secrets.cargo.token}"
    '';
  };
}
