{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;

      keymaps = {
        # Find files using Telescope command-line sugar.
        "<leader>ff" = {
          action = "find_files";
          options.desc = "Find files";
        };
        "<leader>fg" = {
          action = "live_grep";
          options.desc = "Live Grep";
        };
        "<leader>b" = {
          action = "buffers";
          options.desc = "Find buffers";
        };
        "<leader>fh" = {
          action = "help_tags";
          options.desc = "Find help";
        };
        "<leader>fd" = {
          action = "diagnostics";
          options.desc = "Find diagnostics";
        };

        # FZF like bindings
        "<C-p>" = "git_files";
        "<leader>p" = {
          action = "oldfiles";
          options.desc = "Find Recent";
        };
        "<C-f>" = "live_grep";
      };

      settings = {
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
    plugins.web-devicons.enable = true;
  };
}
