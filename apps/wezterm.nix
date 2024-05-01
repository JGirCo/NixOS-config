{ config, lib, pkgs, theme, font, ... }:

with config.colorScheme.palette; {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''

      -- This table will hold the configuration.
      local config = {}

      -- In newer versions of wezterm, use the config_builder which will
      -- help provide clearer error messages
      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      config.colors = {
          foreground = '#${base05}',
          background = '#${base00}',

          cursor_bg = '#${base05}',
          cursor_fg = '#${base00}',
          cursor_border = '#${base05}',

          selection_fg = '#${base05}',
          selection_bg = '#${base00}',

          scrollbar_thumb = '#${base00}',

          split = '#${base00}',

        ansi = {
          '#${base00}',
          '#${base08}',
          '#${base0B}',
          '#${base0A}',
          '#${base0D}',
          '#${base0E}',
          '#${base0C}',
          '#${base05}',
        },
        brights = {
          '#${base03}',
          '#${base09}',
          '#${base01}',
          '#${base02}',
          '#${base04}',
          '#${base06}',
          '#${base0F}',
          '#${base07}',
        },
        }
      config.font = wezterm.font '${font} Nerd Font'
      config.hide_tab_bar_if_only_one_tab = true
      config.audible_bell="Disabled"
      -- config.window_background_opacity = 0.60
      -- config.text_background_opacity = 0.0

      config.window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
      }
      -- and finally, return the configuration to wezterm
      return config
    '';
  };
}
