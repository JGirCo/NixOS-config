{ config, lib, pkgs, theme, font, ... }:

with config.colorScheme.palette; {
  programs.ghsotty = {
    enable = true;
    settings = {

      font-size = 16;
      theme = "default";
    };
    enableZshIntegration = true;
    themes = {
      default = {
        foreground = "#${base05}";
        background = "#${base00}";
        # background_opacity = 0.75;
        # background_tint = 0;
        selection_foreground = "#${base05}";
        selection_background = "#${base02}";

        palette = [
          "0 = #${base00}"
          "1 = #${base08}"
          "2 = #${base0B}"
          "3 = #${base09}"
          "4 = #${base0D}"
          "5 = #${base0E}"
          "6 = #${base0C}"
          "7 = #${base06}"

          "8 = #${base03}"
          "9 = #${base08}"
          "10 = #${base0B}"
          "11 = #${base0A}"
          "12 = #${base0D}"
          "13 = #${base0E}"
          "14 = #${base0C}"
          "15 = #${base05}"
        ];
      };

      enable_audio_bell = "no";
      confirm_os_window_close = 0;
    };
    keybindings = {
      "alt+n" = "new_os_window_with_cwd";
      "alt+space" = "launch --stdin-source=@screen --type=overlay  nvim -R";
    };
  };
}
