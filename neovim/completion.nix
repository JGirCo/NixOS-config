{
  programs.nixvim = {
    opts.completeopt = [ "menu" "menuone" "noselect" ];

    plugins = {
      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp-treesitter.enable = true;
      luasnip.enable = true;

      lspkind = {
        enable = false;

        cmp = {
          enable = true;
          menu = {
            nvim_lsp = "[LSP]";
            nvim_lua = "[api]";
            path = "[path]";
            luasnip = "[snip]";
            buffer = "[buffer]";
            neorg = "[neorg]";
            cmp_tabby = "[Tabby]";
          };
        };
      };

      cmp = {
        enable = true;
        settings = {
          autoEnableSources = true;
          performance = { debounce = 150; };
          sources = [
            { name = "path"; }
            {
              name = "nvim_lsp";
              keywordLength = 3;
            }
            {
              name = "buffer";
              keywordLength = 3;
            }
            { name = "supermaven"; }
          ];

          snippet.expand =
            "function(args) require('luasnip').lsp_expand(args.body) end";
          formatting = {
            fields = [ "menu" "abbr" "kind" ];
            format = ''
              function(entry, item)
                local menu_icon = {
                  nvim_lsp = '[LSP]',
                  luasnip = '[SNIP]',
                  buffer = '[BUF]',
                  path = '[PATH]',
                }

                item.menu = menu_icon[entry.source.name]
                return item
              end
            '';
          };

          window = {
            completion = {
              border = "rounded";
              winhighlight =
                "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None";
              zindex = 1001;
              scrolloff = 0;
              colOffset = 0;
              sidePadding = 1;
              scrollbar = true;
            };
            documentation = {
              border = "rounded";
              winhighlight =
                "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None";
              zindex = 1001;
              maxHeight = 20;
            };
          };
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" =
              "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };

        };
      };
    };
  };
}
