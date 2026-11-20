{ self, inputs, ...}: {

  flake.nixosConfigurations.hpLaptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hpLaptopConfiguration
    ];
  };

}
