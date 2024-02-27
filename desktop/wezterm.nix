{ config, lib, pkgs, theme, ... }:

let
  color_scheme = import ./colors.nix;
in
with color_scheme.${theme};{
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

        -- This is where you actually apply your config choices

        -- For example, changing the color scheme:
        config.color_scheme = "${key.wezterm}"
        config.font = wezterm.font 'FantasqueSansM Nerd Font'
        config.hide_tab_bar_if_only_one_tab = true
        config.window_background_opacity= 0.85
        config.text_background_opacity = 0.5
        config.audible_bell="Disabled"

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
