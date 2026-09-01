{
  pkgs,
  name,
  rebuildCommand,
}:
pkgs.writeShellApplication {
  inherit name;

  text = ''
    config_dir="''${NIX_CONFIG_DIR:-$HOME/.nix-config}"

    cd "$config_dir"

    ${pkgs.git}/bin/git add --all
    sudo ${rebuildCommand} --flake .
  '';
}
