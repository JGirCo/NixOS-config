{ lib, theme, font, ... }:

let
  colors = import ../colors.nix {
    inherit theme;
    inherit lib;
  };
in with colors; {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "top";
        # modules-left = [ "pulseaudio" "backlight" "memory" "cpu" ];
        modules-left = [ "pulseaudio" "cava" "backlight" "memory" "cpu" ];
        modules-center = [ "sway/workspaces" "sway/mode" "sway/scratchpad" ];
        modules-right = [ "battery" "clock" "tray" ];

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
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
        };

        "cava" = {
          framerate = 30;
          autosens = 1;
          bars = 12;
          bar_delimiter = 0;
          method = "pulse";
          format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
        };

        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-icons = [ "" "" "" ];
          format-muted = "";
          on-click = "pavucontrol";
        };

        "sway/scratchpad" = { format = " "; };

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "I";
            "2" = "II";
            "3" = "III";
            "4" = "IV";
            "5" = "V";
            "6" = "VI";
            "7" = "VII";
            "8" = "VIII";
            "9" = "IX";
            "10" = "";
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
          format-icons = [ " " " " " " " " " " ];
        };
        "clock" = {
          interval = 60;
          format = "{:%H:%M}  ";
          format-alt = "{:%A, %B %d, %Y (%R)} 󰃭 ";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            # on-scroll = 1;
            format = {
              months = "<span color='${text2}'><b>{}</b></span>";
              days = "<span color='${inactive}'>{}</span>";
              weekdays = "<span color='${alt}'><b>{}</b></span>";
              today = "<span color='${focused}'><b>{}</b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = [ "tz_up" "shift_up" ];
            on-scroll-down = [ "tz_down" "shift_down" ];
          };
        };
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: ${font} Nerd Font;
        font-size: 13px;
        min-height: 1em;
      }

      window#waybar {
        background: ${base};
        color: ${text2};
        opacity: 0.85;
      }

      tooltip {
        border-radius: 10px;
        background-color: ${base};
      }

      tooltip label {
        color: ${text2};
        font-size: 16px;
        text-shadow: 0px 0px 0px ${base};
      }
      #pulseaudio {
        background: ${green};
        color: ${base};
        border-radius: 6px 0px 0px 6px;
        margin-left: 4px;
        /* margin-right: 4px; */
        padding-right: 8px;
      }

      #cava {
        background: ${green};
        color: ${base};
        border-radius: 0px 6px 6px 0px;
        margin-right: 4px;
        padding-left: 8px;
        padding-right: 8px;
      }

      #backlight {
        background: ${text2};
        color: ${base};
        border-radius: 6px;
        padding-right: 1px;
      }

      #cpu {
        background: ${blue};
        color: ${base};
        border-radius: 0px 6px 6px 0px;
        margin-right: 4px;
      }

      #memory{
        background: ${blue};
        color: ${base};
        border-radius: 6px 0px 0px 6px;
        margin-left: 4px;
      }

      #clock{
        background: ${purple};
        color: ${base};
        margin: 0 4px;
        border-radius: 6px;
      }

      #tray{
        background: ${orange};
        margin: 0 4px;
        border-radius: 6px;
      }

      #workspaces button,
      #cpu,
      #memory,
      #pulseaudio,
      #backlight,
      #tray,
      #clock {
        padding: 0 6px;
      }

      #battery{
        background: ${green};
        color: ${base};
        padding: 0 6px;
        padding-right: 6px;
        margin: 0 2px;
        border-radius: 6px;
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
        animation-duration: 0.5s;
        animation-timing-function: steps(12);
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

       #mode {
          background: ${pink};
          color: ${base};
          border-radius: 6px;
          padding: 0 6px;
          margin-left: 6px;
          margin-right: 6px;
       }

       #workspaces {
          margin-left: 12px;
          margin-right: 12px;
          margin-bottom: 0;
          transition: none;
          background: ${inactive};
          border-radius: 6px;
       }

       #workspaces button {
          background: transparent;
          color: ${base};
          border-radius: 6px;
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
