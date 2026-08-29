{
  imports = [
    ./mini.nix
    ./auto-save.nix
    ./hlchunks.nix
    ./knap.nix
    ./typst.nix
    ./navic.nix
    ./navbuddy.nix
    ./hop.nix
    ./undotree.nix
    ./image.nix
    ./which-key.nix
    ./none-ls.nix
    ./lsp.nix
    ./lualine.nix
    ./neo-tree.nix
    ./tagbar.nix
    ./telescope.nix
    ./treesitter.nix
    ./hardtime.nix
    ./gitsigns.nix
    ./goto-preview.nix
    ./trouble.nix
  ];

  programs.nixvim = {
    files."after/ftplugin/markdown.lua" = {
      localOpts.conceallevel = 1;
      opts = {
        wrap = true;
        breakindent = true;
        linebreak = true;
      };
    };

    plugins = {
      smear-cursor.enable = true;
      treesitter-context = {
        enable = true;
      };
      plantuml-syntax.enable = true;

      colorizer = {
        enable = true;
        settings.user_default_options.names = true;
      };
      oil.enable = true;
      markview.enable = true;
      lsp-lines.enable = true;
      tiny-inline-diagnostic = {
        enable = true;
        settings = {
          multilines.enabled = true;
          multilines.always_show = true;
        };
      };
      nix.enable = true;
      indent-blankline = {
        enable = true;
        settings.scope = {
          enabled = false;
          show_end = true;
          show_exact_scope = true;
          show_start = true;
        };
      };
    };
  };

}
