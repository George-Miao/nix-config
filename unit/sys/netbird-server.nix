{
  unit,
  secrets,
  secret,
  ...
}:
let
  secret = secrets.netbird;
  turn_password = builtins.toFile "turn_password" secret.coturn_password;
  relay_password = builtins.toFile "relay_password" secret.relay_password;
  datastore_key = builtins.toFile "datastore_key" secret.datastore_key;
  turn_secret = builtins.toFile "turn_secret" secret.turn_secret;
in
{
  imports = [ unit.sys.acme ];
  networking.firewall = {
    allowedTCPPorts = [
      80
      443
      33073
      10000
      33080
    ];
    allowedUDPPorts = [ 3478 ];
    allowedUDPPortRanges = [
      {
        from = 49152;
        to = 65535;
      }
    ];
  };
  services.nginx.virtualHosts.${secret.domain} = {
    enableACME = true;
    forceSSL = true;
  };

  services.netbird.server = {
    domain = secret.domain;
    enable = true;
    enableNginx = true;

    coturn = {
      enable = true;
      passwordFile = turn_password;
    };

    management = {
      oidcConfigEndpoint = secret.oidc_config;
      dnsDomain = secret.dns_domain;
      settings = {
        DataStoreEncryptionKey._secret = datastore_key;
        TURNConfig = {
          Secret._secret = turn_secret;
          Turns = [
            {
              Proto = "udp";
              URI = "turn:${secret.domain}:3478";
              Username = "netbird";
              Password._secret = turn_password;
            }
          ];
        };
        Relay = {
          Addresses = [
            "rel://${secret.domain}:443"
          ];
          Secret._secret = relay_password;
        };
        Signal.URI = "${secret.domain}:443";
        IdpManagerConfig = {
          ManagerType = "zitadel";
          ClientConfig = {
            Issuer = secret.oidc_authority;
            TokenEndpoint = "${secret.oidc_authority}/oauth/v2/token";
            ClientID = "netbird";
            ClientSecret = secret.client_secret;
            GrantType = "client_credentials";
          };
          ExtraConfig = {
            ManagementEndpoint = "${secret.oidc_authority}/management/v1";
          };
        };
        HttpConfig = {
          AuthIssuer = secret.oidc_authority;
          AuthAudience = secret.client_id;
          AuthKeysLocation = "${secret.oidc_authority}/oauth/v2/keys";
          oidcConfigEndpoint = secret.oidc_config;
        };
        DeviceAuthorizationFlow = {
          Provider = "hosted";
          ProviderConfig = {
            Audience = secret.client_id;
            ClientID = secret.client_id;
            TokenEndpoint = "${secret.oidc_authority}/oauth/v2/token";
            DeviceAuthEndpoint = "${secret.oidc_authority}/oauth/v2/device_authorization";
            Scope = "openid";
          };
        };
        PKCEAuthorizationFlow.ProviderConfig = {
          ClientID = secret.client_id;
          ClientSecret = "";
          Audience = secret.client_id;
          AuthorizationEndpoint = "${secret.oidc_authority}/oauth/v2/authorize";
          TokenEndpoint = "${secret.oidc_authority}/oauth/v2/token";
          DeviceAuthEndpoint = "";
          Scopes = "openid profile email offline_access api";
          UseIDToken = false;
          RedirectURI = [
            "https://${secret.domain}/peer"
            "https://${secret.domain}/peers"
            "http://localhost:53000/"
          ];
        };
      };
    };
    dashboard = {
      settings = {
        AUTH_AUTHORITY = secret.oidc_authority;
        AUTH_SUPPORTED_SCOPES = "openid profile email offline_access api";
        AUTH_AUDIENCE = secret.client_id;
        AUTH_CLIENT_ID = secret.client_id;
        USE_AUTH0 = false;
        AUTH_REDIRECT_URI = "/peer";
        AUTH_SILENT_REDIRECT_URI = "/peers";
        NETBIRD_TOKEN_SOURCE = "accessToken";
        NGINX_SSL_PORT = "443";
      };
    };
  };
}
