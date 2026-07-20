#!/usr/bin/env bash

set -euo pipefail

environment="prod"
project_id=""
infisical_command="${INFISICAL_COMMAND:-infisical}"

usage() {
  cat <<'EOF'
Usage: import-infisical-secrets.sh [--env ENV] [--project-id ID]

Read a JSON object from stdin and import its leaves as root-level Infisical
secrets with dot-separated names. Every value is stored as JSON text so its type
can be restored during Nix evaluation.

Example:
  printf '%s\n' '{"github":{"token":"secret"}}' \
    | import-infisical-secrets.sh --env prod
EOF
}

require_value() {
  if [[ $# -lt 2 || -z "$2" ]]; then
    echo "Error: $1 requires a value." >&2
    usage >&2
    exit 2
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --env)
      require_value "$@"
      environment="$2"
      shift 2
      ;;
    --project-id)
      require_value "$@"
      project_id="$2"
      shift 2
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      echo "Error: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

temporary_dir="$(mktemp -d "${TMPDIR:-/tmp}/infisical-import.XXXXXX")"
input_file="$temporary_dir/input.json"
records_file="$temporary_dir/records.jsonl"
value_files=()
secret_args=()

cleanup() {
  local value_file
  rm -f -- "$input_file" "$records_file"
  for value_file in "${value_files[@]}"; do
    rm -f -- "$value_file"
  done
  rmdir -- "$temporary_dir" 2>/dev/null || true
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM
chmod 700 "$temporary_dir"

cat > "$input_file"
chmod 600 "$input_file"

if ! jq -e '
  def valid_object:
    all(to_entries[];
      (.key
        | length > 0
        and (contains(".") | not)
        and (contains("/") | not)
        and (contains("=") | not)
        and (test("[\\r\\n]") | not)
      )
      and (if (.value | type) == "object" then (.value | valid_object) else true end)
    );
  type == "object" and valid_object
' "$input_file" > /dev/null; then
  echo "Error: JSON keys must be non-empty and must not contain '.', '/', '=', or newlines." >&2
  exit 1
fi

if ! jq -c '
  def leaves($path):
    to_entries[] as $entry
    | if ($entry.value | type) == "object" then
        ($entry.value | leaves($path + [$entry.key]))
      else
        {
          key: (($path + [$entry.key]) | join(".")),
          value: $entry.value
        }
      end;
  leaves([])
' "$input_file" > "$records_file"; then
  echo "Error: failed to flatten input JSON." >&2
  exit 1
fi
chmod 600 "$records_file"

infisical_args=("--env=$environment" --silent)
if [[ -n "$project_id" ]]; then
  infisical_args+=("--projectId=$project_id")
fi

count=0
while IFS= read -r record; do
  secret_key="$(printf '%s\n' "$record" | jq -r '.key')"
  value_file="$temporary_dir/value-$count"
  value_files+=("$value_file")

  printf '%s\n' "$record" | jq -jr '.value | tojson' > "$value_file"
  chmod 600 "$value_file"
  secret_args+=("$secret_key=@$value_file")

  count=$((count + 1))
done < "$records_file"

if [[ $count -gt 0 ]]; then
  "$infisical_command" secrets set \
    --path=/ \
    "${infisical_args[@]}" \
    -- \
    "${secret_args[@]}"
fi

echo "Imported $count secret(s) into Infisical environment '$environment'."
