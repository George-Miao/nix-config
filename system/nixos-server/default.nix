{
  self,
  config,
  ...
}: {
  flake = {
    nixosModules = {
      server.imports = [
        ../shared
        self.nixosModules.home-manager
        {home-manager.users.${config.user} = {imports = [self.homeModules.server];};}
      ];
    };
  };
}
