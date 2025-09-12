{
  imports = [
    ./mini.nix
    ./auto-save.nix
    # ./codecompanion.nix
    ./hlchunks.nix
    # ./vim-table-mode.nix
    ./knap.nix
    ./typst.nix
    ./navic.nix
    ./barbecue.nix
    ./navbuddy.nix
    ./hop.nix
    ./undotree.nix
    ./transparent.nix
    ./image.nix
    # ./surround.nix
    ./which-key.nix
    # ./comment.nix
    ./none-ls.nix
    ./barbar.nix
    # ./floaterm.nix
    # ./harpoon.nix
    ./lsp.nix
    ./lualine.nix
    ./markdown-preview.nix
    # ./neorg.nix
    ./neo-tree.nix
    # ./startify.nix
    ./tagbar.nix
    ./telescope.nix
    ./treesitter.nix
    ./hardtime.nix
    # ./vimtex.nix
  ];

  programs.nixvim = {

    plugins = {
      vimwiki.enable = true;
      smear-cursor.enable = true;
      treesitter-context = {
        enable = true;
        settings = { separator = "-"; };
      };
      # gitsigns = {
      #   enable = true;
      #   settings = {
      #     signs = {
      #       add.text = "+";
      #       change.text = "~";
      #     };
      #   };
      # };
      nvim-autopairs.enable = true;
      plantuml-syntax.enable = true;

      colorizer = {
        enable = true;
        settings.user_default_options.names = true;
      };
      oil.enable = true;
      # lsp-lines.enable = true;
      tiny-inline-diagnostic = {
        enable = true;
        settings = {
          multilines.enabled = true;
          multilines.always_show = true;
        };
      };
      nix.enable = true;
      # rainbow-delimiters.enable = true;
      indent-blankline = {
        enable = true;
        settings.scope = {
          enabled = false;
          show_end = true;
          show_exact_scope = true;
          show_start = true;
        };
      };
      transparent = {
        enable = true;
        autoLoad = true;
      };
    };
  };
}
