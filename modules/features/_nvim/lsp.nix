{
  pkgs,
  ...
}:
{
  programs.nvf.settings.vim = {
    diagnostics = {
      enable = true;
      config.virtual_lines = true;

      nvim-lint = {
        enable = true;
      };
    };

    lsp = {
      enable = true;
      formatOnSave = true;
      lightbulb.enable = true;
      lspSignature.enable = true;
      trouble.enable = true;
      nvim-docs-view.enable = true;
      inlayHints.enable = true;

      servers.nixd.settings.nil.nix.autoArchive = true;

      presets.tailwindcss-language-server.enable = true;
    };

    debugger = {
      nvim-dap.enable = true;

      nvim-dap.ui = {
        enable = true;
        autoStart = true;
      };
    };

    languages = {
      lua.enable = true;

      nix = {
        enable = true;

        format.enable = true;
        format.type = [ "nixfmt" ];
      };

      sql.enable = false; # Breaks formatting on a lot of queries
      typescript.enable = true;
      svelte.enable = true;
      clojure.enable = false;
      html.enable = true;
      css.enable = true;
      bash.enable = true;
      python = {
        enable = true;
        extraDiagnostics.enable = false;
      };
      markdown.enable = true;
      rust.enable = true;
      go.enable = true;
      haskell.enable = true;

      yaml.enable = true;

      terraform.enable = true;

      enableTreesitter = true;
      enableFormat = true;
      enableExtraDiagnostics = true;
    };

    spellcheck = {
      enable = true;
      programmingWordlist.enable = true;
    };

    treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      typescript # in language settings only tsx gets enabled, not typescript
    ];

    git.enable = true;
  };
}
