{ lib, theme, font, ... }:
let
  colors = import ../colors.nix {
    inherit theme;
    inherit lib;
  };
in with colors; {
  services.dunst.enable = true;
  services.dunst.settings = {
    global = {
      width = 300;
      height = 300;
      origin = "top-right";
      offset = "8x8";
      separator_height = 2;
      padding = 8;
      font = "#${font} Nerd Font 13";
      corner_radius = 10;
    };

    urgency_low = {
      background = "#${base}";
      foreground = "#${text2}";
      frame_color = "#${focused}";
      timeout = 10;
      frame_width = 2;
    };

    urgency_normal = {
      background = "#${base}";
      foreground = "#${text2}";
      frame_color = "#${focused}";
      timeout = 10;
      frame_width = 2;
    };

    urgency_critical = {
      background = "#${urgent}";
      foreground = "#${text}";
      timeout = 120;
      frame_color = "#${urgent}";
      frame_width = 0;
    };
  };
}
