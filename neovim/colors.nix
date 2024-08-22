{ config, theme, lib, ... }:
let
  colors = import ../colors.nix {
    inherit theme;
    inherit lib;
  };
in with colors; {
  programs.nixvim = {
    colorschemes = if nvimEngine == "builtin" then
      {
        ${key.nvim}.enable = true;
      } // lib.optionalAttrs (theme == "catppuccin-latte") {
        catppuccin.enable = true;
        catppuccin.settings.flavour = "latte";
      }
    else if nvimEngine == "base16" then {
      base16 = if isBase16Builtin then {
        enable = true;
        colorscheme = key.nvim;
      } else {
        enable = true;
        colorscheme = with config.colorScheme.palette; {
          base00 = "#${base00}";
          base01 = "#${base01}";
          base02 = "#${base02}";
          base03 = "#${base03}";
          base04 = "#${base04}";
          base05 = "#${base05}";
          base06 = "#${base06}";
          base07 = "#${base07}";
          base08 = "#${base08}";
          base09 = "#${base09}";
          base0A = "#${base0A}";
          base0B = "#${base0B}";
          base0C = "#${base0C}";
          base0D = "#${base0D}";
          base0E = "#${base0E}";
          base0F = "#${base0F}";
        };
      };
    } else {
      palette = {
        enable = true;
        settings = {
          italics = true;
          palettes = {
            main = "pastel";
            accent = "pastel";
            state = "pastel";
          };
          custom_palettes = {
            main = {
              pastel = with config.colorScheme.palette; {
                color0 = "#${base00}";
                color1 = "#${base01}";
                color2 = "#${base02}";
                color3 = "#${base03}";
                color4 = "#${base03}";
                color5 = "#${base04}";
                color6 = "#${base05}";
                color7 = "#${base06}";
                color8 = "#${base07}";
              };
            };
            accent = {
              custom = {
                accent0 = blue;
                accent1 = orange;
                accent2 = inactive;
                accent3 = yellow;
                accent4 = green;
                accent5 = red;
                accent6 = purple;
              };
            };
            state = {
              custom = {
                error = red;
                warning = yellow;
                hint = alt;
                ok = green;
                info = focused;
              };
            };
          };
        };
      };
    };
  };
}
