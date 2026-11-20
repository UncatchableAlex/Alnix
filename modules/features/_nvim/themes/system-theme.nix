{ pkgs, ... }:
let
  moonfly-nvim-pkg = pkgs.vimUtils.buildVimPlugin {
    name = "moonfly-nvim";
    src = pkgs.fetchFromGitHub {
      "owner" = "bluz71";
      "repo" = "vim-moonfly-colors";
      "rev" = "2c883835f5b7b380a0a9e80695c420f7efebdfe4";
      "hash" = "sha256-5Uv9DsUPasnPbBVK6+1WLzZUhV2gcS94CUaQVcds8Uc=";
    };
  };
in
{
  programs.nvf = {
    settings.vim.extraPlugins = {
      moonfly = {
        package = moonfly-nvim-pkg;
        setup = "";
      };
      base16 = {
        package = pkgs.vimPlugins.base16-nvim;
        setup = ''
          local colors_path = vim.fn.expand("~/.cache/noctalia/nvim-base16.lua")
          local mode_path = vim.fn.stdpath("state") .. "/theme-mode"   -- remembers your choice

          local function read_mode()
            local f = io.open(mode_path, "r")
            if not f then return "noctalia" end
            local m = f:read("*l"); f:close()
            return m == "moonfly" and "moonfly" or "noctalia"
          end

          local mode = read_mode()

          local function apply()
            if mode == "noctalia" then
              local ok, colors = pcall(dofile, colors_path)
              if ok and type(colors) == "table" then
                require("base16-colorscheme").setup(colors)
                return
              end
            end
            vim.cmd.colorscheme("moonfly")   -- chosen, or fallback if the noctalia file is missing
          end

          apply()
          vim.api.nvim_create_autocmd("Signal", { pattern = "SIGUSR1", callback = apply })

          vim.api.nvim_create_user_command("ThemeToggle", function()
            mode = (mode == "noctalia") and "moonfly" or "noctalia"
            local f = io.open(mode_path, "w")
            if f then f:write(mode); f:close() end
            apply()
            vim.notify("theme: " .. mode)
          end, { desc = "Toggle between noctalia and moonfly" })
        '';
      };

    };
  };
}
