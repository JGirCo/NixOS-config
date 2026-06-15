{ theme, lib, ... }:
let
  colors = import ../../colors.nix {
    inherit theme;
    inherit lib;
  };
in
{
  programs.nixvim.plugins.bufferline = {
    enable = true;
    settings = {
      highlights = {
        buffer_selected = {
          bg = "#${colors.focused}";
          fg = "#${colors.base}";
        };
        tab_selected = {
          bg = "#${colors.focused}";
          fg = "#${colors.base}";
        };
        modified_selected = {
          fg = "#${colors.base}";
          bg = "#${colors.focused}";
        };

        separator_selected = {
          fg = "#${colors.base}";
          bg = "#${colors.focused}";
        };

        background = {
          fg = "#${colors.base}";
          bg = "#${colors.inactive}";
        };

        separator = {
          fg = "#${colors.base}";
          bg = "#${colors.inactive}";
        };

        buffer_visible = {
          bg = "#${colors.alt}";
          fg = "#${colors.base}";
        };

        modified_visible = {
          fg = "#${colors.base}";
          bg = "#${colors.alt}";
        };

        separator_visible = {
          fg = "#${colors.base}";
          bg = "#${colors.alt}";
        };

      };
      options = {
        offsets = [
          {
            filetype = "neo-tree";
            highlight = "Directory";
            text = "File Explorer";
            text_align = "center";
          }
          {
            filetype = "undotree";
            highlight = "Directory";
            text = "Undotree";
            text_align = "center";
          }
        ];
        # separator_style = [ ""  "" ];
        separator_style = "slant";
        always_show_bufferline = true;
        indicator = {
          style = "none";
        };
        show_buffer_close_icons = false;

      };
    };
  };
}
