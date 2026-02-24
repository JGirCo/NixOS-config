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
        action.__raw = ''function() require("goto-preview").goto_preview_def() end'';
        options.desc = "Preview definition";
      }
      {
        mode = [ "n" ];
        key = "<leader>pD";
        action.__raw = ''function() require("goto-preview").goto_preview_declaration() end'';
        options.desc = "Preview declaration";
      }
      {
        mode = [ "n" ];
        key = "<leader>pr";
        action.__raw = ''function() require("goto-preview").goto_preview_references() end'';
        options.desc = "Preview references";
      }
      {
        mode = [ "n" ];
        key = "<leader>pc";
        action.__raw = ''function() require("goto-preview").close_all_win() end'';
        options.desc = "Close all preview windows";
      }
    ];
  };
}
