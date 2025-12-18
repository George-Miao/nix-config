{
  mount,
  timezone ? "America/New_York",
  webui ? true,
  port ? 8080,
}:
{ lib, secrets, ... }:
{
  virtualisation.oci-containers.containers.cloudpd = {
    image = "icloudpd/icloudpd:latest";
    environment = {
      TZ = "America/New_York";
    };
    volumes = [ "${mount}:/data" ];
    ports = lib.optional webui "${builtins.toString port}:8080";
    cmd = lib.flatten [
      "icloudpd"
      "--directory"
      "/data"
      "--username"
      "${secrets.cloudpd.username}"
      "--smtp-host"
      "${secrets.smtp.host}"
      "--smtp-password"
      "${secrets.smtp.password}"
      "--smtp-username"
      "${secrets.smtp.username}"
      "--notification-email"
      "gm@miao.dev"
      "--notification-email-from"
      "icloudpd@miao.dev"
      (lib.optional webui [
        "--password-provider"
        "webui"
      ])
      (lib.optional webui [
        "--mfa-provider"
        "webui"
      ])
    ];
  };
}
