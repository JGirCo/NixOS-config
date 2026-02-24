{
  programs.nixvim = {
    plugins.trouble = {
      enable = true;
    };

    keymaps = [
      {
        mode = [ "n" ];
        key = "<leader>xx";
        action.__raw = ''function() require("trouble").toggle() end'';
        options.desc = "Toggle trouble";
      }
      {
        mode = [ "n" ];
        key = "<leader>xw";
        action.__raw = ''function() require("trouble").open({ mode = "workspace_diagnostics" }) end'';
        options.desc = "Workspace diagnostics";
      }
      {
        mode = [ "n" ];
        key = "<leader>xd";
        action.__raw = ''function() require("trouble").open({ mode = "document_diagnostics" }) end'';
        options.desc = "Document diagnostics";
      }
    ];
  };
}
