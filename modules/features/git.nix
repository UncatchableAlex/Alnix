{
  flake.nixosModules.home = {
    home-manager.users.alexm.programs.git = {
      enable = true;
      settings.user.name = "Alex Meislich";
      settings.user.email = "alex.meislich@gmail.com";
    };
  };
}
