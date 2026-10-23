{
  lib,
  pkgs,
  secrets,
  ...
}:
let
  webuiPort = 8080;
  torrentingPort = 6881;
  hostname = "bt-lux.miao.dev";
  zoneName = "miao.dev";
  tunnelName = "lux-qbittorrent";
  tunnelSetup = pkgs.writeShellApplication {
    name = "setup-qbittorrent-cloudflare-tunnel";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.curl
      pkgs.jq
    ];
    text = ''
      api="''${CLOUDFLARE_API_URL:-https://api.cloudflare.com/client/v4}"
      auth_header="Authorization: Bearer $CLOUDFLARE_API_TOKEN"

      check_response() {
        if ! jq -e '.success == true' >/dev/null <<< "$1"; then
          jq -c '.errors' <<< "$1" >&2
          exit 1
        fi
      }

      tunnels="$(
        curl --silent --show-error --fail-with-body \
          --header "$auth_header" \
          "$api/accounts/$CLOUDFLARE_ACCOUNT_ID/cfd_tunnel?name=${tunnelName}&is_deleted=false"
      )"
      check_response "$tunnels"
      tunnel_id="$(jq -r '.result[0].id // empty' <<< "$tunnels")"

      if [[ -z "$tunnel_id" ]]; then
        tunnel="$(
          curl --silent --show-error --fail-with-body \
            --request POST \
            --header "$auth_header" \
            --json '${
              builtins.toJSON {
                name = tunnelName;
                config_src = "cloudflare";
              }
            }' \
            "$api/accounts/$CLOUDFLARE_ACCOUNT_ID/cfd_tunnel"
        )"
        check_response "$tunnel"
        tunnel_id="$(jq -er '.result.id' <<< "$tunnel")"
      fi

      tunnel_config="$(
        jq -cn \
          --arg hostname '${hostname}' \
          '{
            config: {
              ingress: [
                {
                  hostname: $hostname,
                  service: "http://127.0.0.1:${builtins.toString webuiPort}",
                  originRequest: {}
                },
                { service: "http_status:404" }
              ]
            }
          }'
      )"
      response="$(
        curl --silent --show-error --fail-with-body \
          --request PUT \
          --header "$auth_header" \
          --json "$tunnel_config" \
          "$api/accounts/$CLOUDFLARE_ACCOUNT_ID/cfd_tunnel/$tunnel_id/configurations"
      )"
      check_response "$response"

      zones="$(
        curl --silent --show-error --fail-with-body \
          --get \
          --header "$auth_header" \
          --data-urlencode 'name=${zoneName}' \
          "$api/zones"
      )"
      check_response "$zones"
      zone_id="$(jq -er '.result[0].id' <<< "$zones")"

      records="$(
        curl --silent --show-error --fail-with-body \
          --get \
          --header "$auth_header" \
          --data-urlencode 'name=${hostname}' \
          "$api/zones/$zone_id/dns_records"
      )"
      check_response "$records"
      record_id="$(jq -r '.result[0].id // empty' <<< "$records")"
      dns_record="$(
        jq -cn \
          --arg name '${hostname}' \
          --arg content "$tunnel_id.cfargotunnel.com" \
          '{ type: "CNAME", name: $name, content: $content, proxied: true }'
      )"

      if [[ -z "$record_id" ]]; then
        response="$(
          curl --silent --show-error --fail-with-body \
            --request POST \
            --header "$auth_header" \
            --json "$dns_record" \
            "$api/zones/$zone_id/dns_records"
        )"
      else
        response="$(
          curl --silent --show-error --fail-with-body \
            --request PUT \
            --header "$auth_header" \
            --json "$dns_record" \
            "$api/zones/$zone_id/dns_records/$record_id"
        )"
      fi
      check_response "$response"

      token="$(
        curl --silent --show-error --fail-with-body \
          --header "$auth_header" \
          "$api/accounts/$CLOUDFLARE_ACCOUNT_ID/cfd_tunnel/$tunnel_id/token"
      )"
      check_response "$token"
      umask 077
      jq -er '.result' <<< "$token" > "$RUNTIME_DIRECTORY/token"
    '';
  };
in
{
  users = {
    groups.cloudflared-qbittorrent = { };
    users.cloudflared-qbittorrent = {
      isSystemUser = true;
      group = "cloudflared-qbittorrent";
    };
  };

  systemd.services = {
    cloudflared-qbittorrent-setup = {
      description = "Provision the qBittorrent Cloudflare tunnel";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      before = [ "cloudflared-qbittorrent.service" ];
      environment = {
        CLOUDFLARE_ACCOUNT_ID = secrets.cloudflare.account_id;
        CLOUDFLARE_API_TOKEN = secrets.cloudflare.token;
      };
      serviceConfig = {
        Type = "oneshot";
        User = "cloudflared-qbittorrent";
        Group = "cloudflared-qbittorrent";
        RuntimeDirectory = "cloudflared-qbittorrent";
        RuntimeDirectoryMode = "0700";
        RuntimeDirectoryPreserve = true;
        RemainAfterExit = true;
        ExecStart = lib.getExe tunnelSetup;
      };
    };

    cloudflared-qbittorrent = {
      description = "Cloudflare tunnel for qBittorrent";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      requires = [
        "cloudflared-qbittorrent-setup.service"
        "qbittorrent.service"
      ];
      after = [
        "cloudflared-qbittorrent-setup.service"
        "network-online.target"
        "qbittorrent.service"
      ];
      serviceConfig = {
        User = "cloudflared-qbittorrent";
        Group = "cloudflared-qbittorrent";
        ExecStart = "${lib.getExe pkgs.cloudflared} tunnel --no-autoupdate run --token-file /run/cloudflared-qbittorrent/token";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };

  services.qbittorrent = {
    enable = true;
    inherit webuiPort torrentingPort;
    serverConfig = {
      LegalNotice.Accepted = true;
      Preferences = {
        "WebUI\\Address" = "127.0.0.1";
        "WebUI\\ServerDomains" = hostname;
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ torrentingPort ];
    allowedUDPPorts = [ torrentingPort ];
  };
}
