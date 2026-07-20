{
  pkgs,
  name,
  rebuildCommand,
}:
pkgs.writeShellApplication {
  inherit name;

  text = ''
    config_dir="''${NIX_CONFIG_DIR:-$HOME/.nix-config}"
    secrets_dir="$(sudo ${pkgs.coreutils}/bin/mktemp -d /var/run/nix-config-secrets.XXXXXX)"
    secrets_file="$secrets_dir/secrets.json"

    cleanup() {
      sudo ${pkgs.coreutils}/bin/rm -f -- "$secrets_file" || true
      sudo ${pkgs.coreutils}/bin/rmdir -- "$secrets_dir" || true
    }
    trap cleanup EXIT
    trap 'exit 1' HUP INT TERM

    cd "$config_dir"

    echo "fetching secrets from infisical..."
    if ! infisical export --format=json --env=prod \
      | ${pkgs.jq}/bin/jq -e '
          if type != "array" then
            error("expected an array")
          elif all(.[];
            type == "object"
            and (.key | type == "string")
            and (.key | split(".") | all(length > 0))
            and (.value | type == "string")
          ) then
            reduce .[] as $secret ({};
              setpath($secret.key | split("."); $secret.value | fromjson)
            )
          else
            error("every item must contain a dotted key and a JSON-encoded value")
          end
        ' \
      | sudo ${pkgs.coreutils}/bin/tee "$secrets_file" > /dev/null
    then
      echo "Error: Infisical export contains invalid dotted keys or non-JSON values." >&2
      exit 1
    fi
    sudo ${pkgs.coreutils}/bin/chmod 600 "$secrets_file"

    export SECRETS_FILE="$secrets_file"
    ${pkgs.git}/bin/git add --all
    sudo --preserve-env=SECRETS_FILE ${rebuildCommand} --flake . --impure
  '';
}
