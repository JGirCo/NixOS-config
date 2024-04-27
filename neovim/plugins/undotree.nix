{
  programs.nixvim = {
    plugins.undotree = { enable = true; };
    keymaps = [{
      key = "<leader>u";
      mode = "n";
      action = "<cmd>UndotreeToggle<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "[u]ndotree toggle";
      };
    }];
  };
}

