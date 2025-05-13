{
  hostname,
  enable_api ? true,
  include_units ? [],
  extra_settings ? {},
  extra_inputs ? [],
  extra_labels ? {},
  extra_groups ? [],
}: {
  lib,
  secrets,
  ...
}: let
  default_settings = {
    data_dir = "/var/lib/vector";
    api.enabled = enable_api;
    sources = {
      journald = {
        type = "journald";
        include_units = ["sshd"] ++ include_units;
      };
      internal = {
        type = "internal_logs";
      };
    };
    transforms = {
      journald_with_labels = {
        type = "remap";
        inputs = ["journald"];
        source = ''
          .service, err = replace(._SYSTEMD_UNIT, r'^(?<service>.*?)\.service$', "$$service")
        '';
      };
      internal_with_labels = {
        type = "remap";
        inputs = ["internal"];
        source = ''
          .service = "vector"
        '';
      };
    };
    sinks = {
      loki = {
        type = "loki";
        endpoint = secrets.loki.endpoint;
        inputs = ["journald_with_labels" "internal_with_labels"] ++ extra_inputs;
        encoding.codec = "json";
        auth = {
          strategy = "basic";
          user = secrets.loki.username;
          password = secrets.loki.password;
        };
        labels = lib.recursiveUpdate extra_labels {
          instance = hostname;
          service = "{{ .service }}";
        };
      };
    };
  };
in {
  systemd.services.vector.serviceConfig = {
    SupplementaryGroups = extra_groups ++ ["systemd-journal"];
    DynamicUser = lib.mkForce false;
  };
  services.vector = {
    enable = true;
    settings = lib.recursiveUpdate default_settings extra_settings;
  };
}
