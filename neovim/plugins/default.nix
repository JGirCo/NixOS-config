{ pkgs, ... }: {
  imports = [
    ./vim-table-mode.nix
    ./knap.nix
    ./typst.nix
    ./navic.nix
    ./barbecue.nix
    ./navbuddy.nix
    ./hop.nix
    ./undotree.nix
    ./transparent.nix
    ./image.nix
    ./surround.nix
    ./which-key.nix
    ./comment.nix
    ./none-ls.nix
    # ./floaterm.nix
    ./harpoon.nix
    ./lsp.nix
    ./lualine.nix
    ./markdown-preview.nix
    ./neorg.nix
    ./neo-tree.nix
    ./startify.nix
    ./tagbar.nix
    ./telescope.nix
    ./treesitter.nix
    ./hardtime.nix
    # ./vimtex.nix
  ];

  programs.nixvim = {

    plugins = {
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add.text = "+";
            change.text = "~";
          };
        };
      };
      nvim-autopairs.enable = true;
      plantuml-syntax.enable = true;

      colorizer = {
        enable = true;
        settings.user_default_options.names = true;
      };
      oil.enable = true;
      lsp-lines.enable = true;
      indent-blankline = {
        enable = true;
        settings.scope = {
          enabled = true;
          show_end = false;
          show_exact_scope = true;
          show_start = false;
        };
      };
      fugitive.enable = true;
    };
  };
}
