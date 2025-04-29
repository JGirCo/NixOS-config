{ config, theme, lib, font, ... }:

let
  colors = import ../../colors.nix {
    inherit theme;
    inherit lib;
  };
  bbtheme = with config.colorScheme.palette;
    with colors; ''
            {
              "name": "Custom",
              "author": "JGirCo",
              "borders": false,
              "main_font": "${font.name}",
              "headline_font": "${font.name}",
              "code_font": "",
      	      "css": "",
              "thumbnail": "",
              "colors": {
                "ui": "#${base}",
                "back": "#${base02}",
                "dark": "#${base01}",
                "border": "#${base01}",
                "selected": "#${base02}",
                "button": "#${base02}",
                "bright_ui": "#${base02}",
                "accent": "#${focused}",
                "frame": "#${base}",
                "text": "#${text2}",
                "light": "#${text2}",
                "accent_text": "#${base}",
                "bright_ui_text": "#${text2}",
                "subtle_text": "#${text2}",
                "grid": "#${base02}",
                "wireframe": "#${base04}",
                "checkerboard": "#${base02}"
              }
            }
    '';
in {
  xdg = {
    configFile = {
      blockbench = {
        enable = true;
        target = "Blockbench/themes/theme.bbtheme";
        text = bbtheme;
      };
    };
  };
}

