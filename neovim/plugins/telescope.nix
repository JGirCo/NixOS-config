{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;

      keymaps = {
        # Find files using Telescope command-line sugar.
        "<leader>ff" = {action = "find_files"; desc = "Find files";};
        "<leader>fg" = {action = "live_grep"; desc = "Live Grep";};
        "<leader>b" = {action = "buffers"; desc = "Find buffers";};
        "<leader>fh" = {action = "help_tags"; desc = "Find help";};
        "<leader>fd" = {action = "diagnostics"; desc = "Find diagnostics";};

        # FZF like bindings
        "<C-p>" = "git_files";
        "<leader>p" = {action = "oldfiles"; desc = "Find Recent";};
        "<C-f>" = "live_grep";
      };

      keymapsSilent = true;

      defaults = {
        file_ignore_patterns = [
          "^.git/"
          "^.mypy_cache/"
          "^__pycache__/"
          "^output/"
          "^data/"
          "%.ipynb"
        ];
        set_env.COLORTERM = "truecolor";
      };
    };
  };
}
