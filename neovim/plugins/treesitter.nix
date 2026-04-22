{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;

      nixGrammars = true;

      grammarPackages = with pkgs.vimPlugins.nvim-treesitter-parsers; [
        lua
        vim
        vimdoc
        markdown
        nix
        python
        typst
      ];

      settings = {
        highlight.enable = true;
        indent.enable = true;
        incremental_selection.enable = true;
      };
    };
  };
}
