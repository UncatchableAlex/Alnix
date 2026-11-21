{ pkgs, ... }:
{
  # add some lua to make telescope search relative to the current file's directory rather than
  # the directory of the calling shell.
  programs.nvf.settings.vim = {
    extraPackages = [
      pkgs.ripgrep
      pkgs.fd
    ];
    projects.project-nvim.enable = false;

    luaConfigRC.project-root = ''
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function(args)
          if vim.bo[args.buf].buftype ~= "" then return end   -- skip oil, help, terminals, ...
          local root = vim.fs.root(args.buf, { ".git", "flake.nix" })
          if root and root ~= vim.fn.getcwd() then
            vim.fn.chdir(root)
          end
        end,
      })
    '';

    telescope = {
      enable = true;

      extensions = [
        {
          name = "fzf";
          packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
          setup = {
            fzf = {
              fuzzy = true;
            };
          };
        }
      ];
    };
  };
}
