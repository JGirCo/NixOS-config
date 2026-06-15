{
  programs.nixvim = {
    plugins.aerial = {
      enable = true;
      # settings = {
      #   lsp.preference = [
      #     "nil-ls"
      #     "rust-analizer"
      #     "ruff-lsp"
      #     "arduino-language-server"
      #     "clangd"
      #     "ruby-lsp"
      #   ];
      #   lsp.autoAttach = true;
      #   window.size = 60;
      # };
    };
    keymaps = [
      {
        mode = [ "n" ];
        key = "<leader>v";
        action = ":AerialNavToggle<CR>";
      }
    ];
  };
}
