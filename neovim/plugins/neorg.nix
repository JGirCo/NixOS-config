{ norgpkg, ... }: {
  programs.nixvim = {
    files."after/ftplugin/norg.lua" = {
      localOpts.conceallevel = 1;
      opts = {
        wrap = true;
        breakindent = true;
        linebreak = true;
      };

      keymaps = [
        {
          mode = "n";
          key = "<C-g>";
          action = ":Neorg toc<CR>";
          options.silent = true;
        }
        {
          mode = "i";
          key = "<C-c>";
          action = "<Esc>b~ea";
          options = {
            silent = true;
            noremap = true;
            desc = "Change the case of the first letter of the current word";
          };
        }
      ];
    };

    plugins.neorg = {
      enable = true;
      package = norgpkg.vimPlugins.neorg;

      settings.lazy_loading = true;

      settings.load = {
        "core.defaults" = { __empty = null; };
        "core.dirman" = {
          config = {
            workspaces = {
              notes = "~/notes";
              thesis = "~/Documents/thesis";
            };
          };
        };
        "core.concealer" = { config = { icon_preset = "basic"; }; };
        "core.export".__empty = null;
        "core.completion".config.engine = "nvim-cmp";
        "core.qol.toc".config.close_after_use = true;
      };
    };
  };
}
