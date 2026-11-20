{
  flake.nixosModules.home = {
    home-manager.users.alexm.programs.kitty = {
        enable = true;
        settings.confirm_os_window_close = 0;
        extraConfig = "include themes/noctalia.conf";   # noctalia kitty template
    };
  };
}
