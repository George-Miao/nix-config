{ ... }:
{
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      cosmos-server = {
        image = "azukaar/cosmos-server:latest";
        hostname = "cosmos-server";
        extraOptions = [
          "--privileged"
          "--network=host"
        ];
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
          "/var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket"
          "/:/mnt/host"
          "/var/lib/cosmos:/config"
        ];
      };
    };
  };
}
