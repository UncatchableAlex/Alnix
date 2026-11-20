{ inputs, ... }: {
  perSystem = { pkgs, lib, ... }: {
    packages.alexNoctalia = inputs.wrapper-modules.wrappers.noctalia.wrap {
      inherit pkgs;
      settings = lib.recursiveUpdate (builtins.fromTOML (builtins.readFile ./noctalia.toml)) {
        theme.templates.user.nvim = {
          input_path = "${./nvim-base16.lua}";
          output_path = "~/.cache/noctalia/nvim-base16.lua";
          post_hook = "pkill -USR1 nvim || true";
        };
      };
    };
  };
}
