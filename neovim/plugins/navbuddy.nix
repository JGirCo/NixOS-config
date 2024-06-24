{
  programs.nixvim = {
    plugins.navbuddy = {
      enable = true;
      lsp.preference = [
        "nil-ls"
        "rust-analizer"
        "ruff-lsp"
        "arduino-language-server"
        "clangd"
      ];
      lsp.autoAttach = true;
    };
    keymaps = [{
      mode = [ "n" ];
      key = "<leader>v";
      action = ":Navbuddy<CR>";
    }];
  };
}

