{
  imports = [
    ./image.nix
    ./surround.nix
    ./which-key.nix
    ./barbar.nix
    ./comment.nix
    ./efm.nix
    ./floaterm.nix
    ./harpoon.nix
    ./lsp.nix
    ./lualine.nix
    # ./markdown-preview.nix
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

      nvim-colorizer = {
        enable = true;
        userDefaultOptions.names = false;
      };
      oil.enable = true;
    };
  };
}
