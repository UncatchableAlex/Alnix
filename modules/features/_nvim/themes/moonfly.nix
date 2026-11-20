{ pkgs, ... }:
let
  moonfly-nvim-pkg = pkgs.vimUtils.buildVimPlugin {
    name = "moonfly-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "bluz71";
      repo = "vim-moonfly-colors";
      rev = "master";
      sha256 = "sha256-5Uv9DsUPasnPbBVK6+1WLzZUhV2gcS94CUaQVcds8Uc=";
    };
  };
in
{
  programs.nvf = {
    settings.vim.extraPlugins.moonfly = {
      package = moonfly-nvim-pkg;
      setup = ''vim.cmd("colorscheme moonfly")'';
    };
  };
}
