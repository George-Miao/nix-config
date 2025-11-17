{ ... }:
{
  system.activationScripts.mkdir-caprover = ''
    mkdir -p /captain
  '';
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      caprover = {
        image = "caprover/caprover:latest";
        hostname = "caprover";
        environment = {
          ACCEPTED_TERMS = "true";
        };
        extraOptions = [
          "--privileged"
          "--network=host"
        ];
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
          "/captain:/captain"
        ];
      };
    };
  };

  networking.firewall =
    let
      range = {
        from = 8000;
        to = 65535;
      };
    in
    {
      allowedTCPPorts = [
        80
        443
        3000
      ];
      allowedUDPPorts = [
        80
        443
        3000
      ];

      # For apps that need to bind to a port
      allowedTCPPortRanges = [ range ];
      allowedUDPPortRanges = [ range ];
    };

  ## Cluster networking
  # networking.firewall = {
  #   allowedTCPPorts = [80 443 996 2377 3000 4789 7946];
  #   allowedUDPPorts = [2377 4789 7946];
  # };
}
