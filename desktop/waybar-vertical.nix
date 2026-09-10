{
  lib,
  font,
  config,
  colors,
  ...
}:

let
  themeLib = import ../lib/theme.nix {
    inherit config lib colors;
  };
  inherit (themeLib.semantic)
    bg
    fg
    accent
    secondary
    alt
    blue
    green
    yellow
    orange
    red
    purple
    pink
    ;
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        position = "left";
        layer = "top";
        width = 40;
        margin-left = 8;
        margin-bottom = 8;
        margin-top = 8;

        modules-left = [
          "group/audio"
          "backlight"
          "group/hardware"
        ];
        modules-center = [ "niri/workspaces" ];
        modules-right = [
          "battery"
          "clock"
          # "network"
          "tray"
        ];

        "group/audio" = {
          orientation = "vertical";
          modules = [
            "mpris"
            "cava"
            "pulseaudio"
          ];
        };

        "cava" = {
          rotate = 270;
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

        "group/hardware" = {
          orientation = "vertical";
          modules = [
            "memory"
            "cpu"
            "temperature"
          ];
        };

        "cpu" = {
          interval = 2;
          format = "<span font_size='12pt'>{usage}%</span>\n󰾆";
          tooltip-format = "{usage}% Usage";
          justify = "center";
        };

        "memory" = {
          interval = 10;
          format = "<span font_size='12pt'>{}%</span>\n ";
          tooltip-format = "{}% RAM";
          justify = "center";
        };

        "temperature" = {
          interval = 10;
          format = "<span font_size='12pt'>{}°</span>\n";
          tooltip-format = "{}°C";
          justify = "center";
        };

        "battery" = {
          interval = 5;
          states = {
            warning = 30;
            critical = 10;
          };
          format-charging = "<span font_size='12pt'>{capacity}%</span>\n󱐋\n{icon}";
          format-full = "";
          format = "<span font_size='12pt'>{capacity}%</span>\n{icon}";
          tooltip-format = "{capacity}% Battery";
          format-icons = [
            " "
            " "
            " "
            " "
            " "
          ];
          justify = "center";
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
          format = "<span font_size='25pt'>󰽰</span>";
          tooltip-format = "{dynamic}";
          player-icons = {
            default = "󰽰";
          };
          status-icons = {
            paused = "󰏤";
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
        # network = {
        #   format-wifi = "{icon}";
        #   format-ethernet = "󰈀 ";
        #   format-disconnected = "󰤭 ";
        #   format-icons = [
        #     "󰤯 "
        #     "󰤟 "
        #     "󰤢 "
        #     "󰤥 "
        #     "󰤨 "
        #   ];
        #   tooltip-format = "{essid} - {signalStrength}%";
        # };
      };
    };

    style = ''
      /* Color Palette - Catppuccin Macchiato flavor */
      @define-color base     ${bg};
      @define-color focused     ${accent};
      @define-color text     ${fg};
      @define-color blue     ${blue};
      @define-color alt      ${alt};
      @define-color orange   ${orange};
      @define-color purple   ${purple};
      @define-color green    ${green};
      @define-color inactive ${secondary};
      @define-color yellow   ${yellow};
      @define-color red      ${red};
      @define-color pink     ${pink};

      * {
        font-family: "${font.sans.name}";
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
      #cava,
      #pulseaudio,
      #memory,
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
        padding: 0;
        margin: 0;
      }
      #waybar #cpu label {
        margin-right: 20px; /* Manually nudge the label until it looks centered */
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
        padding: 10px 5px;
      }
      #network {
        background: @pink;
        padding: 10px 5px;
      }
      #tray {
        background: @base;
      }
      #battery {
        background: @green;
      }

      /* Dynamic Animations & States */
      #mpris.playing,
      #battery.charging {
          background: linear-gradient(-45deg, @base, @alt, @base);
          background-size: 300% 300%;
          animation: gradient_flow 3s ease infinite;
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
        background: @focused;
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
          0% {
              background-position: 0% 50%;
          }
          50% {
              background-position: 100% 50%;
          }
          100% {
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
