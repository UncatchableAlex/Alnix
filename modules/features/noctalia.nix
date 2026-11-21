{ inputs, ... }: {
  perSystem = { pkgs, lib, ... }: {
    packages.alexNoctalia = inputs.wrapper-modules.wrappers.noctalia.wrap {
      inherit pkgs;
      settings = lib.recursiveUpdate (builtins.fromTOML (builtins.readFile ./noctalia.toml)) {
        theme.templates = {

          enable_community_templates = true;
          community_ids = [
            "pywalfox-beta4"
            "yazi"
          ];
          user = {
            sone = {
              input_path = "${pkgs.writeText "sone-theme.json" (
                builtins.toJSON {
                  version = 1;
                  preset = "custom";
                  custom = {
                    accent = "{{colors.primary.default.hex}}";
                    background = "{{colors.surface.default.hex}}";
                  };
                }
              )}";
              output_path = "~/.config/sone/theme.json";
            };

            nvim = {
              input_path = "${./nvim-base16.lua}";
              output_path = "~/.cache/noctalia/nvim-base16.lua";
              post_hook = "pkill -USR1 nvim || true";

            };
          };
        };
      };
    };
  };
}
