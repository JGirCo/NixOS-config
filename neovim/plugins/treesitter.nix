{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      nixvimInjections = true;

      folding.enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
        ensureInstalled = [
          "markdown"
          "markdown_inline"
          "htl"
          "yaml"
          "typst"
          "nix"
          "arduino"
          "python"
          "rust"
          "norg"
        ];
      };
    };

    # treesitter-refactor = {
    #   enable = true;
    #   settings.highlightDefinitions.enable = true;
    # };

    hmts.enable = true;
  };
}
