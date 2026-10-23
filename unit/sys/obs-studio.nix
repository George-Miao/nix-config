{
  config,
  pkgs,
  ...
}:
let
  v4l2loopback = config.boot.kernelPackages.v4l2loopback.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      rm -f "$out"/lib/modules/*/modules.*
    '';
  });
in
{
  boot = {
    extraModulePackages = [ v4l2loopback ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
    kernelModules = [ "v4l2loopback" ];
  };

  security.polkit.enable = true;

  programs.obs-studio = {
    enable = true;
    # Nixpkgs 0.15.4 installs depmod metadata that conflicts with the kernel.
    enableVirtualCamera = false;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };
}
