{...}: {
  home.file.cargo_config = {
    target = ".cargo/config.toml";
    text = ''
      [build]
      target-dir = "/tmp/rust-target"
    '';
  };
}
