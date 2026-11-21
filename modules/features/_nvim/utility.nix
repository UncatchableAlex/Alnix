{ lib, pkgs, ... }:
{
  programs.nvf.settings.vim = {

    luaConfigRC.treesitter-install-dir = ''
      vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/site")
    '';

    utility.oil-nvim = {
      enable = true;
      setupOpts = {
        default_file_explorer = true;
        skip_confirm_for_simple_edits = true;

        view_options = {
          show_hidden = true;
          natural_order = true;

          is_always_hidden = lib.mkLuaInline ''
            function(name, _)
              return name == ".." or name == ".git"
            end
          '';
        };

        win_options.wrap = true;
      };
    };

    git.gitsigns = {
      enable = true;
      codeActions.enable = true;

      setupOpts = {
        current_line_blame = true;
        current_line_blame_opts = {
          delay = 100;
        };
      };
    };

    options.clipboard = "unnamedplus"; # vim.o.clipboard = 'unnamedplus'
    extraPackages = [
      pkgs.wl-clipboard
      pkgs.tree-sitter
    ]; # wl-copy/wl-paste on nvim's own PATH

    keymaps = [
      {
        key = "-";
        mode = [ "n" ];
        action = ":Oil<CR>";
        silent = true;
        desc = "Open parent directory";
      }
      {
        key = "<C-e>";
        mode = [ "n" ];
        action = "<C-u>"; # noremap is nvf's default
        desc = "Scroll up half a page";
      }
      {
        key = "<leader>tt";
        mode = [ "n" ];
        action = ":ThemeToggle<CR>";
        silent = true;
        desc = "Toggle noctalia/moonfly theme";
      }
    ];

    autopairs.nvim-autopairs.enable = true;
    autocomplete.nvim-cmp.enable = true;
  };
}
