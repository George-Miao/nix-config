PACKAGES=$(
nix flake info . --json | jq -r '
  .locks.nodes.root.inputs
  | with_entries( select(.key as $k | [ "flake-parts", "nixos-flake" ] | index($k) | not) )
  | keys
  | join(" ")'
)

echo $PACKAGES

nix flake update ${PACKAGES}
