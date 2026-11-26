{
  flake.nixosModules.home.home-manager.users.alexm.programs.kitty = {
    enable = true;
    extraConfig = "include themes/noctalia.conf"; # noctalia kitty template
    settings = {
      confirm_os_window_close = 0;
      background_opacity = "0.65";
    };
  };
}
