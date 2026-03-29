{
  config,
  lib,
  pkgs,
  theme,
  font,
  colors,
  ...
}:
let
  inherit (config.lib.formats.rasi) mkLiteral;
in
with colors;
{
  programs.rofi = {
    enable = true;
    font = "${font.sans} 15";

    theme = {
      "*" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "#${text2}";
        margin = 0;
        padding = 0;
        spacing = 0;
      };

      window = {
        location = mkLiteral "center";
        anchor = mkLiteral "center";

        # Relative sizing
        width = mkLiteral "30%";
        # height = mkLiteral "40%";

        # Shifts the window slightly up to match Wofi's top=25%

        border-radius = mkLiteral "20px";
        padding = mkLiteral "20px";
        background-image = mkLiteral ''url("/home/jgirco/Pictures/wallpapers/${theme}.jpg", width)'';
        border = mkLiteral "2px solid";
        border-color = mkLiteral "#${focused}";
      };

      mainbox = {
        spacing = mkLiteral "15px"; # Creates the gap between the search bar and the list
        children = mkLiteral "[ inputbar, listview ]";
      };

      inputbar = {
        padding = mkLiteral "10px";
        border = mkLiteral "2px solid";
        border-radius = mkLiteral "10px";
        border-color = mkLiteral "#${focused}";
        background-color = mkLiteral "#${base}";
        children = mkLiteral "[ entry ]";
      };

      entry = {
        placeholder = "Search...";
        placeholder-color = mkLiteral "#${text2}";
        cursor = mkLiteral "text";
        vertical-align = mkLiteral "0.5";
      };

      listview = {
        columns = 1;
        lines = 8;
        cycle = true;
        dynamic = true;
        scrollbar = false;
        layout = mkLiteral "vertical";
        spacing = mkLiteral "5px"; # Replaces Wofi's margin on entries

        background-color = mkLiteral "#${base}";
        border-radius = mkLiteral "10px";
        padding = mkLiteral "10px";
      };

      element = {
        padding = mkLiteral "8px 10px";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "#${inactive}";
        cursor = mkLiteral "pointer";
        children = mkLiteral "[ element-icon, element-text ]";
      };

      "element selected" = {
        background-color = mkLiteral "#${focused}";
      };

      "element-text" = {
        text-color = mkLiteral "#${base}";
        vertical-align = mkLiteral "0.5";
      };

      "element-text selected" = {
        text-color = mkLiteral "#${base}";
      };

      "element-icon" = {
        size = mkLiteral "24px";
        padding = mkLiteral "0 10px 0 0";
      };

      message = {
        padding = mkLiteral "10px";
      };

      error-message = {
        padding = mkLiteral "20px";
        background-color = mkLiteral "#${base}";
      };
    };
  };
}
