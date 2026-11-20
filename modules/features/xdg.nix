{
  flake.nixosModules.home = {
    home-manager.users.alexm.xdg = {
      mimeApps = {
        enable = true;
        defaultApplications = {
          "image/jpeg" = [ "imv.desktop" ];
          "image/png"  = [ "imv.desktop" ];
          "image/gif"  = [ "imv.desktop" ];
          "image/webp" = [ "imv.desktop" ];
          "video/mp4"  = [ "mpv.desktop" ];
          "video/x-matroska"  = [ "mpv.desktop" ];
          "application/pdf" = [ "org.pwmt.zathura.desktop" ];
          "text/plain" = [ "nvim-term.desktop" ];
        };
      };

      desktopEntries."nvim-term" = {
        name = "Neovim";
        exec = "kitty nvim %f";
        terminal = false;
        type = "Application";
        mimeType = [ "text/plain" ];
      };

      desktopEntries."edit-config" = {
        name = "Edit Alnix Config";
        exec = "kitty nvim /home/alexm/Alnix";
        terminal = false;
        type = "Application";
      };
    };
  };
}
