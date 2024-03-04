{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;

      nixvimInjections = true;

      folding = true;
      indent = true;
      ensureInstalled = [
        "nix"
        "arduino"
        "python"
        "rust"
      ];
    };


    treesitter-refactor = {
      enable = true;
      highlightDefinitions.enable = true;
    };

    hmts.enable = true;
  };
}
