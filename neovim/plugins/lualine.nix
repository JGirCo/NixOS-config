{
  programs.nixvim.plugins.lualine = {
    enable = true;

    settings = {
      disabledFiletypes.statusline = [ "norg" ];
      disabledFiletypes.winbar = [ "norg" ];
      options = {
        component_separators.left = "";
        component_separators.right = "";
        section_separators.left = "";
        section_separators.right = "";
        globalstatus = true;
      };
      # +-------------------------------------------------+
      # | A | B | C                             X | Y | Z |
      # +-------------------------------------------------+
      tabline = {
        lualine_a = [{
          __unkeyed-1 = "buffers";
          separator.left = "";
          separator.right = "";
          symbols = { alternate_file = ""; };
        }];
        lualine_z = [{
          __unkeyed-1 = "tabs";
          separator.left = "";
          separator.right = "";
        }];
      };
      sections = {
        lualine_a = [{
          __unkeyed-1 = "mode";
          separator.left = "";
          separator.right = "";
        }];
        lualine_b = [ "branch" ];
        lualine_c = [ "diff" ];

        lualine_y = [

          # Show active language server
          # {
          # __unkeyed-1 = {
          #   __raw = ''
          #     function()
          #         local msg = ""
          #         local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
          #         local clients = vim.lsp.get_clients()
          #         if next(clients) == nil then
          #             return msg
          #         end
          #         for _, client in ipairs(clients) do
          #             local filetypes = client.config.filetypes
          #             if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
          #                 return client.name
          #             end
          #         end
          #         return msg
          #     end
          #   '';
          # };
          #   icon = "";
          # }
          "lsp_status"
        ];
        lualine_x = [ "diagnostics" ];
        lualine_z = [{
          __unkeyed-1 = "filetype";
          separator.right = "";
          separator.left = "";
          filetype_names = {
            undotree = "Undotree";
            neo-tree = "File Explorer";
          };
        }];
      };
    };
  };
}
