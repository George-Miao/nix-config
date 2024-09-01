{
  self,
  config,
  ...
}: {
  flake = {
    nixosModules = {
      server.imports = [
        ../shared
        ../shared/nixos.nix
        self.nixosModules.home-manager
        ({...}: {
          home-manager.users.${config.user} = {
            imports = [self.homeModules.server];
          };
        })
      ];
    };
  };
}
