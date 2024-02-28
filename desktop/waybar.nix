{ config, lib, pkgs, ... }:

{
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          position = "bottom";
          modules-left = ["pulseaudio" "backlight" "memory" "cpu"];
          modules-center = ["sway/workspaces" "sway/mode" "sway/scratchpad"];
          modules-right = ["battery" "clock" "tray"];

          "cpu" = {
            interval = 10;
            format = "{}%  ";
          };

          "memory" = {
            interval = 10;
            format = "{}%  ";
          };
          "backlight" = {
            format = "{percent}% {icon}";
            format-icons = ["" "" "" "" "" "" "" "" ""];
          };

          "pulseaudio" = {
            format = "{volume}% {icon}";
            format-icons = ["" ""];
            format-muted = "";
          };
          "battery" = {
            interval = 60;
            states = {
              warning = 30;
              critical = 10;
            };
            format = "{capacity}% {icon}";
            format-icons = ["" "" "" "" ""];
          };
          "clock" = {
            interval = 60;
            format = "{:%H:%M}  ";
            format-alt = "{:%A, %B %d, %Y (%R)} 󰃭 ";
          };
        };
      };
      style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: FantasqueSansM Nerd Font;
        font-size: 13px;
        padding: 0;
        margin: 0;
      }
      window#waybar {
        background: #282a36;
        color: #f8f8f2;
        opacity: 0.85;
      }
      #cpu,
      #memory,
      #pulseaudio,
      #backlight,
      #tray,
      #clock,
      #battery {
        padding: 0 10px;
      }
      '';
    };
}
