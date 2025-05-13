{devices}: {secrets, ...}: {
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      scrutiny-collector = {
        image = "ghcr.io/analogj/scrutiny:master-collector";
        hostname = "caprover";
        environment = {
          COLLECTOR_API_ENDPOINT = secrets.scrutiny.collector_api;
          COLLECTOR_RUN_STARTUP = "true";
          COLLECTOR_CRON_SCHEDULE = "0 * * * *";
        };
        extraOptions =
          [
            "--cap-add=SYS_RAWIO"
            "--cap-add=SYS_ADMIN"
          ]
          ++ builtins.map (d: "--device=${d}") devices;
        volumes = ["/run/udev:/run/udev:ro"];
      };
    };
  };
}
