{ config, lib, pkgs, theme, ... }:

let
  colorScheme = import ./colors.nix;
in
with colorScheme.${theme};
{
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          position = "bottom";
          modules-left = ["pulseaudio" "cava" "backlight" "memory" "cpu"];
          modules-center = ["sway/workspaces" "sway/mode" "sway/scratchpad"];
          modules-right = ["battery" "clock" "tray"];

          "cpu" = {
            interval = 10;
            format = "{}% ";
          };

          "memory" = {
            interval = 10;
            format = "{}% ";
          };
          "backlight" = {
            format = "{percent}% {icon}";
            format-icons = ["" "" "" "" "" "" "" "" ""];
          };

          "cava" = {
            framerate = 30;
            autosens = 1;
            bars = 12;
            bar_delimiter = 0;
            method = "pulse";
            format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
          };

          "pulseaudio" = {
            format = "{volume}% {icon}";
            format-icons = ["" ""];
            format-muted = "";
            };

          "sway/scratchpad" = {
            format = " ";
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
        background: ${base};
        color: ${text2};
        opacity: 0.85;
      }

      #pulseaudio,
      #cava {
        background: ${green};
        color: ${base};
      }

      #backlight {
        background: ${text2};
        color: ${base};
      }

      #cpu,
      #memory{
        background: ${blue};
        color: ${base};
      }

      #clock{
        background: ${purple};
        color: ${base};
      }

      #tray{
        background: ${base};
      }

      #cpu,
      #memory,
      #pulseaudio,
      #backlight,
      #tray,
      #clock,
      #cava,
      #battery {
        padding: 0 10px;
      }

      #battery{
        background: ${green};
        color: ${base};
      }

      #battery.warning {
        background: ${yellow};
        color: ${base};
      }

      #battery.charging,
      #battery.plugged {
        background: ${base};
        color: ${base};
      }

      @keyframes blink {
        to {
          background: ${base};
          color: ${text2};
        }
      }

      #battery.critical:not(.charging) {
        background: ${red};
        color: ${base};
        animation-name: blink;
        animation-duration: 2s;
        animation-timing-function: steps(12);
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

       #mode {
          background: ${pink};
          color: ${base};
       }
       #workspaces button.focused {
          background: ${focused};
          color: ${base};
       }

       #workspaces button.visible {
          background: ${inactive};
          color: ${base};
       }

       #workspaces button.urgent {
          background: ${urgent};
          color: ${base};
       }
      '';
    };
}
