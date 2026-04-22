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
        position = "left";
        layer = "top";
        width = 40;

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
          orientation = "vertical";
          modules = [
            "mpris"
            "pulseaudio"
            # "cava" # Removed: Text-based visualizers break vertical constraints.
          ];
        };

        "group/hardware" = {
          orientation = "vertical";
          modules = [
            "memory"
            "cpu"
            "temperature"
          ];
        };

        "cpu" = {
          interval = 10;
          format = "";
          tooltip-format = "{usage}% Usage";
        };

        "memory" = {
          interval = 10;
          format = "";
          tooltip-format = "{}% RAM";
        };

        "temperature" = {
          interval = 10;
          format = "";
          tooltip-format = "{}°C";
        };

        "backlight" = {
          format = "{icon}";
          tooltip-format = "{percent}% Brightness";
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
          tooltip-format = "{dynamic}";
          player-icons = {
            default = "󰝚 ";
          };
          status-icons = {
            paused = "󰏤 ";
          };
        };

        "pulseaudio" = {
          format = "{icon}";
          tooltip-format = "{volume}% Volume";
          format-icons = [
            " "
            " "
            " "
          ];
          format-muted = " ";
          on-click = "pavucontrol";
        };

        "niri/workspaces" = {
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
          format-charging = "󱐋\n{icon}";
          format-full = "";
          format = "{icon}";
          tooltip-format = "{capacity}% Battery";
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
          format = "{:%H\n%M}";
          tooltip-format = "{:%A, %B %d}";
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
      @define-color inactive #${inactive};
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
      #workspaces button,
      #mpris,
      #pulseaudio,
      #memory,
      #cpu,
      #temperature {
          padding: 10px 0;
          color: @base;
          transition: all 0.3s ease;
          margin: 2px 0;
      }

      #audio {
        background: @alt;
      }
      #hardware {
        background: @blue;
      }
      #workspaces {
        background: @inactive;
        padding: 0;
      }
      #backlight {
        background: @text;
      }
      #clock {
        background: @purple;
        padding: 10px 5px !important;
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
        background: linear-gradient(180deg, @base, @alt, @sky, @base);
        background-size: 200% 200%;
        animation: gradient_flow 3s linear infinite;
      }

      #waybar #mpris {
        margin: 0 0;
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
          background-position: 50% 200%;
        }
        to {
          background-position: 50% 0%;
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
          padding: 10px 0;
        }
        30% {
          margin: -4px 0;
          padding: 12px 4px;
        }
        100% {
          margin: 0px;
          padding: 10px 0;
        }
      }

      @keyframes selection_label {
        0% {
          font-size: 20px;
          margin: 0 2px;
        }
        30% {
          font-size: 40px;
          margin: 0 -100px;
        }
        100% {
          font-size: 20px;
          margin: 0 2px;
        }
      }
    '';
  };
}
