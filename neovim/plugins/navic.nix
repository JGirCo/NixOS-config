{
  programs.nixvim = {
    plugins.navic = {
      enable = true;
      separator = "";
      lsp.preference = [
        "nil_ls"
        "rust-analizer"
        "ruff-lsp"
        "arduino-language-server"
        "clangd"
      ];
      lsp.autoAttach = true;
    };
  };
}

