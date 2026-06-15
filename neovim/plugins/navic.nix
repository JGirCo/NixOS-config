{
  programs.nixvim = {
    plugins.navic = {
      enable = false;
      settings = {
        separator = "";
        lsp.preference = [
          "nixd"
          "rust_analizer"
          "ruff_lsp"
          "arduino-language-server"
          "clangd"
          "efm"
        ];
        highlight = true;
      };
    };
  };
}
