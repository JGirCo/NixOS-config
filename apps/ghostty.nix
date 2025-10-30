{ config, lib, pkgs, theme, font, ... }:

with config.colorScheme.palette; {
  programs.ghostty = {
    enable = true;
    settings = {

      font-size = 16;
      font-family = font.name;
      theme = "default";
      window-padding-y = 0;
      window-padding-x = 4;
      keybind = [ "alt+shift+h=previous_tab" "alt+shift+l=next_tab" ];
      linux-cgroup = "never";
    };
    enableZshIntegration = true;
    themes = {
      default = {
        foreground = "#${base05}";
        background = "#${base00}";
        # background-opacity = 0.75;
        # background_tint = 0;
        selection-foreground = "#${base05}";
        selection-background = "#${base02}";

        palette = [
          "0=#${base00}"
          "1=#${base08}"
          "2=#${base0B}"
          "3=#${base09}"
          "4=#${base0D}"
          "5=#${base0E}"
          "6=#${base0C}"
          "7=#${base06}"

          "8=#${base03}"
          "9=#${base08}"
          "10=#${base0B}"
          "11=#${base0A}"
          "12=#${base0D}"
          "13=#${base0E}"
          "14=#${base0C}"
          "15=#${base05}"
        ];
      };
    };
    # keybindings = {
    #   "alt+n" = "new_os_window_with_cwd";
    #   "alt+space" = "launch --stdin-source=@screen --type=overlay  nvim -R";
    # };
  };
}
