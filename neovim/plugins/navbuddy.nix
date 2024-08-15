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
      window.size = 60;
    };
    keymaps = [{
      mode = [ "n" ];
      key = "<leader>v";
      action = ":Navbuddy<CR>";
    }];
  };
}
