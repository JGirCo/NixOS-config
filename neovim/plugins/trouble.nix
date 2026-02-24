{
  programs.nixvim = {
    plugins.trouble = {
      enable = true;
      settings = {
        icons = false;
      };
    };

    keymaps = [
      {
        mode = [ "n" ];
        key = "<leader>xx";
        action.__raw = ''<cmd>TroubleToggle<cr>'';
        options.desc = "Toggle trouble";
      }
      {
        mode = [ "n" ];
        key = "<leader>xw";
        action.__raw = ''<cmd>Trouble workspace_diagnostics<cr>'';
        options.desc = "Workspace diagnostics";
      }
      {
        mode = [ "n" ];
        key = "<leader>xd";
        action.__raw = ''<cmd>Trouble document_diagnostics<cr>'';
        options.desc = "Document diagnostics";
      }
      {
        mode = [ "n" ];
        key = "]w";
        action.__raw = ''<cmd>Trouble<cr>'';
        options.desc = "Next warning";
      }
      {
        mode = [ "n" ];
        key = "[w";
        action.__raw = ''<cmd>Trouble<cr>'';
        options.desc = "Previous warning";
      }
    ];
  };
}
