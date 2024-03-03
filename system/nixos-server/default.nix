{ self, ... }: {
  flake = {
    nixosModules = {
      server.imports = [
        ../shared
        self.nixosModules.home-manager
        {
          home-manager.users.pop = {
            imports = [ self.homeModules.server ];
          };
        }
      ];
    };
  };
}
