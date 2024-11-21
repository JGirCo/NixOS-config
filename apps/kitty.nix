{ config, lib, pkgs, theme, font, ... }:

with config.colorScheme.palette; {
  programs.kitty = {
    enable = true;
    font.name = font.name;
    font.size = 13;
    shellIntegration.enableZshIntegration = true;
    settings = {
      foreground = "#${base05}";
      background = "#${base00}";
      # background_opacity = 0.5;
      # background_tint = 0.5;

      selection_fg = "#${base05}";
      selection_bg = "#${base02}";

      color0 = "#${base00}";
      color1 = "#${base08}";
      color2 = "#${base0B}";
      color3 = "#${base09}";
      color4 = "#${base0D}";
      color5 = "#${base0E}";
      color6 = "#${base0C}";
      color7 = "#${base06}";

      color8 = "#${base03}";
      color9 = "#${base08}";
      color10 = "#${base0B}";
      color11 = "#${base0A}";
      color12 = "#${base0D}";
      color13 = "#${base0E}";
      color14 = "#${base0C}";
      color15 = "#${base05}";

      enable_audio_bell = "no";
    };
  };
}
