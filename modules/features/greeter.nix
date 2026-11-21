{
  flake.nixosModules.greeter = {
    services.displayManager.noctalia-greeter = {
      enable = true;
      settings.default_user = "alexm"; # preselect you; straight to the password field
      passwordlessSyncUsers = [ "alexm" ]; # let Noctalia sync wallpaper/colors without a password prompt
    };
  };
}
