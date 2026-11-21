{
  flake.nixosModules.home =
    { lib, ... }:
    let
      editor = [ "nvim-term.desktop" ];
      textTypes = [
        "text/plain"
        "text/markdown"
        "text/x-nix"
        "text/x-haskell"
        "text/x-python"
        "text/x-lua"
        "text/x-csrc"
        "text/x-chdr"
        "text/x-c++src"
        "application/x-shellscript"
        "application/json"
        "application/toml"
        "application/yaml"
        "application/x-yaml"
        "x-rust"
        "rust"
      ];
    in
    {
      home-manager.users.alexm.xdg = {
        mimeApps = {
          enable = true;
          defaultApplications = lib.genAttrs textTypes (_: editor) // {
            "image/jpeg" = [ "imv.desktop" ];
            "image/png" = [ "imv.desktop" ];
            "image/gif" = [ "imv.desktop" ];
            "image/webp" = [ "imv.desktop" ];
            "video/mp4" = [ "mpv.desktop" ];
            "video/x-matroska" = [ "mpv.desktop" ];
            "application/pdf" = [ "org.pwmt.zathura.desktop" ];
            "text/plain" = [ "nvim-term.desktop" ];
            "text/nix" = [ "nvim-term.desktop" ];
            "text/hs" = [ "nvim-term.desktop" ];
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
