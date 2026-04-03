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
        # We use groups here for the shared background/animation benefits
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
            default = "󰎆 ";
          };
          status-icons = {
            paused = "󰏤 ";
          };
        };

        "cava" = {
          framerate = 30;
          hide_on_silence = true;
          stereo = false;
          autosens = 1;
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
          format-plugged = "";
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
      @keyframes selection {
        0% {
          margin-top: 0px;
          margin-bottom: 0px;
          padding-top: 0px;
          padding-bottom: 0px;
        }
        30% {
          margin-top: -4px;
          margin-bottom: -4px;
          padding-bottom: 4px;
          padding-top: 4px;
        }
        100% {
          margin-top: 0px;
          margin-bottom: 0px;
          padding-top: 0px;
          padding-bottom: 0px;
        }
      }

      @keyframes gradient_flow {
        0% { background-position: 200% 50%; }
        100% { background-position: 0% 50%; }
      }

      /* Global Reset - Restoring your 13px scale */
      * {
        border: none;
        font-family: "${font.name}";
        font-size: 16px;
        min-height: 0;
        margin: 2px;
        margin-bottom: 0px;
        border-radius: 999px;
      }

      /* This creates that 20px "up" margin gap you missed */
      window#waybar {
        background: rgba(0,0,0,0);
        color: #${text2};
        padding-top: 20px;
      }

      /* --- Audio Group (The Animated Pill) --- */

      #audio {
        background: #${alt};
        margin: 5px 2px 0 2px;
        border-radius: 999px;
        min-height: 24px;
      }

      #mpris, #pulseaudio, #cava {
        background: transparent;
        color: #${base};
        margin: 0;
        padding: 0;
      }

      #mpris {
        border-radius: 999px;
        padding: 0 5px 0 10px;
        transition: all 0.3s ease;
      }

      #mpris.playing {
        background: linear-gradient(90deg, #${base},#${alt},#${alt}, #${base});
        background-size: 200% 200%;
        animation: gradient_flow 3s linear infinite;
        color: #${base};
      }

      #pulseaudio {
        padding: 0 8px 0 4px;
      }

      #cava {
        padding: 0 12px 0 4px;
        border-radius: 0 999px 999px 0;
      }

      /* --- Hardware Group (The Blue Pill) --- */
      #hardware {
        background: #${blue};
        color: #${base};
      }

      #hardware * {
        margin: 0;
      }

      #memory {
        padding: 0 4px 0 10px;
        background: transparent;
      }

      #cpu {
        padding: 0 4px;
        background: transparent;
      }

      #temperature {
        padding: 0 10px 0 4px;
        background: transparent;
      }

      /* --- Workspaces --- */
      #workspaces {
        background: #${inactive};
      }

      #workspaces button {
        font-size: 16px;
        background: transparent;
        color: #${base};
        padding: 0 6px;
        padding-bottom: 3px;
        margin: 0px;
      }

      #workspaces button label {
          font-size: 20px;
          padding: 0;
          margin: 0;
      }

      #workspaces button.active {
        font-size: 20px;
        background: #${focused};
        color: #${base};
        animation-name: selection;
        animation-duration: 1s;
        padding-left: 8px;
        padding-right: 8px;
      }

      #workspaces button label {
          font-size: 20px;
          font-weight: bold;
          padding: 0;
          margin: 0;
      }

      /* --- The Rest of the Modules --- */
      #backlight {
        background: #${text2};
        color: #${base};
        padding: 0 8px;
      }

      #clock {
        background: #${purple};
        color: #${base};
        padding: 0 10px;
      }

      #tray {
        background: #${orange};
        padding: 0 10px;
      }

      #battery {
        background: #${green};
        color: #${base};
        padding: 0 10px;
      }
      #battery.charging,
      #battery.plugged {
        background: #${base};
        color: #${text2};
      }

      #battery.warning { background: #${yellow}; }
      #battery.critical:not(.charging) {
        background: #${red};
        animation: blink 0.5s steps(12) infinite alternate;
      }

      @keyframes blink {
        to { background: #${base}; color: #${text2}; }
      }

      tooltip {
        border-radius: 0.5rem;
        background-color: #${base};
      }

      tooltip label {
        color: #${text2};
        font-size: 13px;
      }
    '';
  };
}
