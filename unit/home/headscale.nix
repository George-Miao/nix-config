{
  pkgs,
  secrets,
  ...
}:
{
  home.packages = with pkgs; [
    headscale
  ];

  home.file.headscale_config = {
    target = ".headscale/config.yaml";
    text = ''
      cli:
        address: "${secrets.headscale.address}"
        api_key: "${secrets.headscale.api_key}"
    '';
  };
}
