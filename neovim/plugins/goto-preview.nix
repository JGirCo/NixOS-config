{
  programs.nixvim = {
    plugins.goto-preview = {
      enable = true;
      settings = {
        default_mappings = false;
      };
    };

    keymaps = [
      {
        mode = [ "n" ];
        key = "<leader>pd";
        action.__raw = ''lua require("goto-preview").goto_preview_def()'';
        options.desc = "Preview definition";
      }
      {
        mode = [ "n" ];
        key = "<leader>pD";
        action.__raw = ''lua require("goto-preview").goto_preview_declaration()'';
        options.desc = "Preview declaration";
      }
      {
        mode = [ "n" ];
        key = "<leader>pr";
        action.__raw = ''lua require("goto-preview").goto_preview_references()'';
        options.desc = "Preview references";
      }
      {
        mode = [ "n" ];
        key = "<leader>pc";
        action.__raw = ''lua require("goto-preview").close_all_win()'';
        options.desc = "Close all preview windows";
      }
    ];
  };
}
