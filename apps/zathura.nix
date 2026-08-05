{
  lib,
  config,
  theme,
  colors,
  ...
}:

let
  themeLib = import ../lib/theme.nix {
    inherit lib colors;
    palette = config.colorScheme.palette;
  };
in
{
  programs.zathura = {
    enable = true;
    options = {
      default-bg = themeLib.semantic.bg;
      default-fg = themeLib.semantic.fg;

      statusbar-fg = themeLib.terminal.brights.black;
      statusbar-bg = themeLib.terminal.colors.black;

      inputbar-bg = themeLib.semantic.bg;
      inputbar-fg = themeLib.semantic.fg;

      notification-bg = themeLib.semantic.bg;
      notification-fg = themeLib.semantic.fg;

      notification-error-bg = themeLib.semantic.bg;
      notification-error-fg = themeLib.semantic.red;

      notification-warning-bg = themeLib.semantic.bg;
      notification-warning-fg = themeLib.semantic.red;

      highlight-color = themeLib.terminal.brights.yellow;
      highlight-active-color = themeLib.terminal.colors.blue;

      completion-bg = themeLib.terminal.brights.black;
      completion-fg = themeLib.terminal.colors.blue;

      completion-highlight-fg = themeLib.semantic.fg;
      completion-highlight-bg = themeLib.terminal.colors.blue;

      recolor-lightcolor = themeLib.semantic.bg;
      recolor-darkcolor = themeLib.semantic.fg;

      recolor = "true";
      recolor-keephue = "true";

      selection-clipboard = "clipboard";
    };
  };
}
