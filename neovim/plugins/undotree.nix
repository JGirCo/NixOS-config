{
  programs.nixvim = {
    plugins.undotree = {
      enable = true;
      settings = {
        WindowLayout = 3;
        TreeNodeShape = "󰴈 ";
        SetFocusWhenToggle = true;
        SplitWidth = 40;
        DiffpanelHeight = 10;
      };
    };
    keymaps = [
      {
        key = "<leader>u";
        mode = "n";
        action = "<cmd>UndotreeToggle | UndotreeFocus<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "[u]ndotree toggle";
        };
      }
    ];
  };
}
