{
  programs.nixvim = {
    plugins.gitsigns = {
      enable = true;
      settings = {
        signs = {
          add.text = "+";
          change.text = "~";
        };
      };
    };

    keymaps = [
      {
        mode = [ "n" ];
        key = "]c";
        action.__raw = ''
          function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(require('gitsigns').next_hunk)
                    return '<Ignore>'
                  end'';
        options.desc = "Next hunk";
      }
      {
        mode = [ "n" ];
        key = "[c";
        action.__raw = ''
          function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(require('gitsigns').prev_hunk)
                    return '<Ignore>'
                  end'';
        options.desc = "Previous hunk";
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>ghs";
        action = "<cmd>Gitsigns stage_hunk<CR>";
        options.desc = "Stage hunk";
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>ghr";
        action = "<cmd>Gitsigns reset_hunk<CR>";
        options.desc = "Reset hunk";
      }
      {
        mode = [ "n" ];
        key = "<leader>ghS";
        action.__raw = "require('gitsigns').stage_buffer";
        options.desc = "Stage buffer";
      }
      {
        mode = [ "n" ];
        key = "<leader>ghu";
        action.__raw = "require('gitsigns').undo_stage_hunk";
        options.desc = "Undo stage hunk";
      }
      {
        mode = [ "n" ];
        key = "<leader>ghR";
        action.__raw = "require('gitsigns').reset_buffer";
        options.desc = "Reset buffer";
      }
      {
        mode = [ "n" ];
        key = "<leader>ghp";
        action.__raw = "require('gitsigns').preview_hunk";
        options.desc = "Preview hunk";
      }
      {
        mode = [ "n" ];
        key = "<leader>ghb";
        action.__raw = "function() require('gitsigns').blame_line({ full = true }) end";
        options.desc = "Blame line";
      }
      {
        mode = [ "n" ];
        key = "<leader>ghd";
        action.__raw = "require('gitsigns').diffthis";
        options.desc = "Diff this";
      }
      {
        mode = [ "n" ];
        key = "<leader>gh/";
        action.__raw = "require('gitsigns').toggle_current_line_blame";
        options.desc = "Toggle blame";
      }
    ];
  };
}
