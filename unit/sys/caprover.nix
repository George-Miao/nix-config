{...}: {
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

  networking.firewall = {
    allowedTCPPorts = [80 443 3000 996 7946 4789 2377];
    allowedUDPPorts = [7946 4789 2377];
  };
}
