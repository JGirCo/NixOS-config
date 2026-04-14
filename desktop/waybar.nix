{
  lib,
  theme,
  font,
  colors,
  ...
}:
with colors;
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "top";
        layer = "top";
        height = 32;

        modules-left = [
          "group/audio"
          "backlight"
          "group/hardware"
        ];
        modules-center = [ "niri/workspaces" ];
        modules-right = [
          "battery"
          "clock"
          "tray"
        ];

        "group/audio" = {
          orientation = "inherit";
          modules = [
            "mpris"
            "pulseaudio"
            "cava"
          ];
        };

        "group/hardware" = {
          orientation = "inherit";
          modules = [
            "memory"
            "cpu"
            "temperature"
          ];
        };

        "cpu" = {
          interval = 10;
          format = "{usage}%  ";
        };
        "memory" = {
          interval = 10;
          format = "{}%  ";
        };
        "temperature" = {
          interval = 10;
          format = "{}°C  ";
        };
        "backlight" = {
          format = "{percent}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };

        "mpris" = {
          format = "{player_icon}";
          player-icons = {
            default = "󰝚 ";
          };
          status-icons = {
            paused = "󰏤 ";
          };
        };

        "cava" = {
          framerate = 60;
          hide_on_silence = true;
          stereo = false;
          autosens = 1;
          sensitivity = 4;
          bars = 12;
          bar_delimiter = 0;
          method = "pulse";
          format-icons = [
            "▁"
            "▂"
            "▃"
            "▄"
            "▅"
            "▆"
            "▇"
            "█"
          ];
        };

        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-icons = [
            " "
            " "
            " "
          ];
          format-muted = " ";
          on-click = "pavucontrol";
        };

        "niri/workspaces" = {
          # format = "{icon}";
          format = "<b>{icon}</b>";
          format-icons = {
            "1" = "α";
            "2" = "β";
            "3" = "γ";
            "4" = "δ";
            "5" = "ε";
            "6" = "ϛ";
            "7" = "ζ";
            "8" = "η";
            "9" = "θ";
            "10" = " ";
          };
        };

        "battery" = {
          interval = 5;
          states = {
            warning = 30;
            critical = 10;
          };
          format-charging = "{capacity}% 󱐋{icon}";
          format-full = "";
          format = "{capacity}% {icon}";
          format-icons = [
            " "
            " "
            " "
            " "
            " "
          ];
        };

        "clock" = {
          interval = 60;
          format = "{:%H:%M}  ";
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
      };
    };

    style = ''
      /* Color Palette - Catppuccin Macchiato flavor */
      @define-color base     #${base};
      @define-color text     #${text2};
      @define-color blue     #${blue};
      @define-color alt      #${alt};
      @define-color orange   #${focused};
      @define-color purple #${purple};
      @define-color green    #${green};
      @define-color inactive    #${inactive};
      @define-color yellow   #${yellow};
      @define-color red      #${red};

      * {
        font-family: "${font.sans}";
        font-size: 20px;
        border: none;
        border-radius: 999px;
      }

      window#waybar {
        background: rgba(55, 55, 55, 0);
        color: @text;
      }

      #waybar .module:not(#workspaces),
      /* #waybar .module, */
      #workspaces button,
      #mpris,
      #pulseaudio,
      #cava,
      #memory,
      #cpu,
      #temperature {
        padding: 0 10px;
        color: @base;
        transition: all 0.3s ease;
        margin: 0 4px;
      }

      #audio {
        background: @alt;
      }
      #hardware {
        background: @blue;
      }
      #workspaces {
        background: @inactive;
        padding: 0; /* This kills the inherited module padding */
      }
      #backlight {
        background: @text;
      }
      #clock {
        background: @purple;
      }
      #tray {
        background: @orange;
      }
      #battery {
        background: @green;
      }

      /* Dynamic Animations & States */
      #mpris.playing,
      #battery.charging {
        background: linear-gradient(90deg, @base, @alt, @sky, @base);
        background-size: 200% 200%;
        animation: gradient_flow 3s linear infinite;
      }

      #battery.warning:not(.charging) {
        background: @yellow;
      }
      #battery.critical:not(.charging) {
        background: @red;
        animation: blink 0.5s steps(12) infinite alternate;
      }

      #waybar #battery.full {
        background: @base;
        color: @text;
      }

      /* Workspace Logic */

      #waybar #workspaces button {
        margin: 0 0;
        animation: selection 1s;
      }

      #workspaces button.active {
        background: @orange;
        animation: selection 1s;
      }

      #workspaces button label {
        font-size: 20px;
        font-weight: bold;
      }
      #workspaces button.active label {
        animation: selection_label 1s;
      }

      /* Tooltips */
      tooltip {
        background: @base;
        border-radius: 8px;
      }
      tooltip label {
        color: @text;
        font-size: 13px;
      }

      /* Keyframes */
      @keyframes gradient_flow {
        from {
          background-position: 200% 50%;
        }
        to {
          background-position: 0% 50%;
        }
      }

      @keyframes blink {
        from {
          background: @base;
          color: @text;
        }
        to {
          background: @red;
          color: @base;
        }
      }

      @keyframes selection {
        0% {
          margin: 0px;
          padding: 0 10px;
        }
        30% {
          margin: -4px;
          padding: 4px 12px;
        }
        100% {
          margin: 0px;
          padding: 0 10px;
        }
      }

      @keyframes selection_label {
        0% {
          font-size: 20px;
          margin: 2px 0;
        }
        30% {
          font-size: 40px;
          margin: -100px 0;
        }
        100% {
          font-size: 20px;
          margin: 2px 0;
        }
      }
    '';
  };
}
