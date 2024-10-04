{
  config,
  flake,
  ...
}: {
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;

  home-manager.users.${flake.config.user}.imports = [
    flake.self.unit.home.obs-studio
  ];
}
