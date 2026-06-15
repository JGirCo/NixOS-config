{ theme, lib, ... }:
let
  colors = import ../../colors.nix {
    inherit theme;
    inherit lib;
  };
in
{
  programs.nixvim = {

    highlightOverride.BufferDefaultCurrent = {
      fg = "#${colors.base}";
      bg = "#${colors.focused}";
      italic = true;
      bold = true;
    };

    highlightOverride.BufferCurrentMod = {
      fg = "#${colors.base}";
      bg = "#${colors.focused}";
      italic = true;
      bold = true;
    };

    highlightOverride.BufferVisible = {
      fg = "#${colors.base}";
      bg = "#${colors.focused}";
    };

    highlightOverride.BufferVisibleMod = {
      fg = "#${colors.base}";
      bg = "#${colors.focused}";
    };
    highlightOverride.BufferVisibleSign = {
      fg = "#${colors.focused}";
      bg = "#${colors.base}";
    };

    highlightOverride.BufferCurrentSign = {
      fg = "#${colors.focused}";
      bg = "#${colors.base}";
    };

    highlightOverride.BufferInactive = {
      fg = "#${colors.base}";
      bg = "#${colors.inactive}";
    };

    highlightOverride.BufferInactiveMod = {
      fg = "#${colors.base}";
      bg = "#${colors.inactive}";
    };

    highlightOverride.BufferInactiveSign = {
      fg = "#${colors.focused}";
    };

    plugins.barbar = {
      enable = true;
      keymaps = {
        next.key = "<M-l>";
        previous.key = "<M-h>";
        close.key = "<M-w>";
      };
      settings = {
        preset = "slanted";
        animation = true;
        highlight_visible = true;
      };
    };
  };
}
