{ config, lib, pkgs, theme, ... }:

let
  colorScheme = import ../colors.nix;
in
with colorScheme.${theme};
{
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          position = "top";
          modules-left = ["pulseaudio" "cava" "backlight" "memory" "cpu"];
          modules-center = ["sway/workspaces" "sway/mode" "sway/scratchpad"];
          modules-right = ["battery" "clock" "tray"];

          "cpu" = {
            interval = 10;
            format = "{}%  ";
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
            format-icons = ["" "" ""];
            format-muted = "";
            };

          "sway/scratchpad" = {
            format = " ";
          };

          "sway/workspaces" = {
            disable-scroll= true;
            all-outputs= true;
            format= "{icon}";
            format-icons = {
              "1"= " ";
              "2"= "";
              "3"= "󰔶";
              "4"= "󰝤";
              "5"= "󰜁";
              "6"= "󰋘";
              "7"= "󰋘  ";
              "8"= "󰋘  ";
              "9"= "󰋘 󰔶 ";
              "10"= "";
            };
          };

          "battery" = {
            interval = 5;
            states = {
              warning = 30;
              critical = 10;
            };
            format = "{capacity}% {icon}";
            format-full = "{capacity}% {icon}";
            format-charging = "{capacity}% 󱐋{icon}";
            format-plugged = "";
            format-icons = [" " " " " " " " " "];
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
        min-height: 10px;
      }

      window#waybar {
        background: ${base};
        color: ${text2};
        opacity: 0.85;
      }

      #pulseaudio {
        background: ${green};
        color: ${base};
        border-radius: 7px 0px 0px 7px;
        margin-left: 4px;
      }

      #cava {
        background: ${green};
        color: ${base};
        border-radius: 0px 7px 7px 0px;
        margin-right: 4px;
      }

      #backlight {
        background: ${text2};
        color: ${base};
        border-radius: 7px;
        padding-right: 1px;
      }

      #cpu {
        background: ${blue};
        color: ${base};
        border-radius: 0px 7px 7px 0px;
        margin-right: 4px;
      }

      #memory{
        background: ${blue};
        color: ${base};
        border-radius: 7px 0px 0px 7px;
        margin-left: 4px;
      }

      #clock{
        background: ${purple};
        color: ${base};
        margin: 0 4px;
        border-radius: 7px;
      }

      #tray{
        background: ${orange};
        margin: 0 4px;
        border-radius: 5px;
      }

      #workspaces button,
      #scratchpad,
      #cpu,
      #memory,
      #pulseaudio,
      #backlight,
      #tray,
      #clock,
      #cava {
        padding: 0 7px;
      }

      #battery{
        background: ${green};
        color: ${base};
        padding: 0 7px;
        padding-right: 7px;
        margin: 0 2px;
        border-radius: 7px;
      }

      #battery.warning {
        background: ${yellow};
        color: ${base};
      }

      #battery.charging,
      #battery.plugged {
        background: ${base};
        color: ${text2};
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
          border-radius: 7px;
          padding: 0 7px;
          margin-left: 5px;
          margin-right: 5px;
       }

       #workspaces {
          margin-left: 12px;
          margin-right: 12px;
          margin-bottom: 0;
          transition: none;
          background: ${inactive};
          border-radius: 7px;
       }

       #workspaces button {
          background: transparent;
          color: ${base};
          border-radius: 7px;
       }

       #workspaces button.focused {
          background: ${focused};
          color: ${base};
       }

       #workspaces button.urgent {
          background: ${urgent};
          color: ${base};
       }
      '';
    };
}
