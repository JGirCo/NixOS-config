{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;

      nixvimInjections = true;

      folding = true;
      settings = {
        indent.enable = true;
        ensureInstalled = [ "nix" "arduino" "python" "rust" "norg" ];
      };
    };

    treesitter-refactor = {
      enable = true;
      highlightDefinitions.enable = true;
    };

    hmts.enable = true;
  };
}
