{ lib, config, theme, ... }:

let
  colors = import ../colors.nix {
    inherit theme;
    inherit lib;
  };
in with colors;
with config.colorScheme.palette; {
  config = {
    programs.zathura = {
      enable = true;
      options = {
        default-bg = "${base}";
        default-fg = "${text2}";

        statusbar-fg = "#${base02}";
        statusbar-bg = "#${base01}";

        inputbar-bg = "${base}";
        inputbar-fg = "${text2}";

        notification-bg = "${base}";
        notification-fg = "${text2}";

        notification-error-bg = "${base}";
        notification-error-fg = "#${base08}";

        notification-warning-bg = "${base}";
        notification-warning-fg = "#${base08}";

        highlight-color = "#${base0A}";
        highlight-active-color = "#${base0D}";

        completion-bg = "#${base03}";
        completion-fg = "#${base0D}";

        completion-highlight-fg = "${text2}";
        completion-highlight-bg = "#${base0D}";

        recolor-lightcolor = "${base}";
        recolor-darkcolor = "${text2}";

        recolor = "true";
        recolor-keephue = "true";

        selection-clipboard = "clipboard";
      };
    };
  };
}
