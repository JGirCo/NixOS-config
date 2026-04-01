{
  config,
  lib,
  pkgs,
  theme,
  colors,
  ...
}:
with colors;
{
  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      theme = "wofi-ported";
      terminal = "kitty";
      list = {
        show_scrollbar = false;
      };
      search = {
        placeholder = "";
      };
      close_when_open = true;
      keybinds = {
        next = [
          "ctrl j"
          "Tab"
        ];
        previous = [
          "ctrl k"
          "shift Tab"
        ];
      };
    };

    themes."wofi-ported" = {
      style = ''
        @define-color accent_bg_color #${focused};
        @define-color theme_fg_color #${text2};
        @define-color inactive_bg_color #${inactive};
        @define-color base_color #${base}; /* Added base color for the text */

        /* Reset all styles */
        * {
          all: unset;
        }

        /* The Background */
        .box-wrapper {
          background-image: url('/home/jgirco/Pictures/wallpapers/${theme}.jpg');
          background-size: cover;
          background-repeat: no-repeat;
          background-position: center;
          padding: 20px;
          border-radius: 20px;
        }

        /* The Search Bar */
        .input {
          caret-color: @theme_fg_color;
          background: @base_color;
          border: 2px solid @accent_bg_color;
          padding: 10px 15px;
          color: @theme_fg_color;
          border-radius: 10px;
          margin-bottom: 20px;
          margin-top: 20px;
        }

        .input placeholder {
          opacity: 0.5;
        }

        /* --- THE LIST ITEMS --- */
        .list {
          background: transparent;
        }

        .item-box {
          border-radius: 10px;
          padding: 10px;
          background: @inactive_bg_color; /* Restores the unselected pill background */
          margin-bottom: 8px; /* Restores the gaps between the pills */
        }
        scrolledwindow {
          background-color: @base_color;
          border-radius: 20px;
          padding: 20px;
        }

        /* Selected state */
        child:hover .item-box,
        child:selected .item-box {
          background: @accent_bg_color;
        }

        /* Text colors inside the pills */
        .item-text {
          font-size: 20px;
          color: @base_color; /* Forces dark text so it is readable on the pills */
        }

        .item-subtext {
          font-size: 12px;
          opacity: 0.7;
          color: @base_color;
        }

        .item-image, .item-image-text {
          margin-right: 10px;
        }

        /* Quick activation labels (F1, F2) with dark background */
        .item-quick-activation {
          margin-left: 10px;
          background-color: @base_color;
          color: @theme_fg_color;
          border-radius: 5px;
          padding: 5px 10px;
          font-weight: bold;
        }

        /* Keybinds at the bottom with dark background */
        .keybinds-wrapper {
          margin-top: 150px;
          background-color: @theme_fg_color;
          opacity: 100;
          padding: 10px 15px;
          border-radius: 10px;
          color: @theme_fg_color;
        }

        .keybind-bind {
          font-weight: bold;
          color: @accent_bg_color;
        }

        /* Other defaults */
        .placeholder, .elephant-hint { color: @theme_fg_color; opacity: 0.5; }
        .normal-icons { -gtk-icon-size: 16px; }
        .large-icons { -gtk-icon-size: 32px; }
        scrollbar { opacity: 0; }
      '';
    };
  };
}
