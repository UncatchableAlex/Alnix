{ inputs, ... }: {
  flake.nixosModules.home = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm-bak";
      users.alexm.home = {
        stateVersion = "26.05";
      };
    };
  };
}
