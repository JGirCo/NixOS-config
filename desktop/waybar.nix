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
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [ "keyboard-state" "battery" "clock" "tray" ];

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

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "Ⅰ";
            "2" = "Ⅱ";
            "3" = "Ⅲ";
            "4" = "Ⅳ";
            "5" = "Ⅴ";
            "6" = "Ⅵ";
            "7" = "Ⅶ";
            "8" = "Ⅷ";
            "9" = "Ⅸ";
            "10" = " ";
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
        keyboard-state = {
          numlock = true;
          format = { numlock = "{icon}"; };
          format-icons = {
            unlocked = "<span color='#${purple}'><b>     </b></span>";
            locked = "<span color='#${orange}'><b>1 2 3 4</b></span>";
          };
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
              months = "<span color='#${text2}'><b>{}</b></span>";
              days = "<span color='#${inactive}'>{}</span>";
              weekdays = "<span color='#${alt}'><b>{}</b></span>";
              today = "<span color='#${focused}'><b>{}</b></span>";
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
      @keyframes selection {
        0%   {margin-top: 0px; padding-bottom: 1px;}
        10%  {margin-top: -4px; padding-bottom: 4px;}
        100% {margin-top: 0px; padding-bottom: 1px;}
      }
      * {
        border: none;
        font-family: "${font.name}";
        font-size: 13px;
        min-height: 0;
        margin: 2px;
        border-radius: 999px;
        margin-bottom: 0px;
      }

      window#waybar {
        background: rgba(0,0,0,0);
        color: #${text2};
        opacity: 1;
        padding-top: 20px;
      }

      tooltip {
        border-radius: 0.5rem;
        background-color: #${base};
      }

      tooltip label {
        color: #${text2};
        font-size: 16px;
        text-shadow: 0px 0px 0px #${base};
      }
      #pulseaudio {
        background: #${green};
        color: #${base};
        border-radius: 999px 0px 0px 999px;
        padding-right: 10px;
        margin-right: 0px;
      }

      #cava {
        background: #${green};
        color: #${base};
        border-radius: 0px 999px 999px 0px;
        /* margin-right: 4px; */
        margin-left: 0px;
        padding-left: 8px;
        padding-right: 8px;
      }

      #backlight {
        background: #${text2};
        color: #${base};
        padding-right: 1px;
      }

      #cpu {
        background: #${blue};
        color: #${base};
        border-radius: 0px 999px 999px 0px;
        margin-left: 0px;
        padding-right: 8px;
      }

      #memory{
        background: #${blue};
        color: #${base};
        border-radius: 999px 0px 0px 999px;
        margin-right: 0px;
      }

      #keyboard-state{
        background: #${base};
        color: #${base};
        padding: 0px 3px;
      }

      #clock{
        background: #${purple};
        color: #${base};
      }

      #tray{
        background: #${orange};
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
        background: #${green};
        color: #${base};
        padding: 0 6px;
        padding-right: 6px;
      }

      #battery.warning {
        background: #${yellow};
        color: #${base};
      }

      #battery.charging,
      #battery.plugged {
        background: #${base};
        color: #${text2};
      }

      @keyframes blink {
        to {
          background: #${base};
          color: #${text2};
        }
      }

      #battery.critical:not(.charging) {
        background: #${red};
        color: #${base};
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: steps(12);
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

       #workspaces {
          transition: none;
          background: #${inactive};
       }

       #workspaces button {
          background: transparent;
          color: #${base};
          padding-bottom: 3px;
          margin: 0px;
       }

       #workspaces button.active {
          background: #${focused};
          color: #${base};
          animation-name: selection;
          animation-duration: 1s;
          padding-left: 8px;
          padding-right: 8px;
       }

       #workspaces button.urgent {
          background: #${urgent};
          color: #${base};
       }
    '';
  };
}
