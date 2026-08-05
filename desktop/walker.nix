{
  inputs,
  theme,
  lib,
  colors,
  ...
}:

let
  themeLib = import ../lib/theme.nix {
    inherit colors lib;
    palette = null;
  };
in
{

  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      theme = "wofi-ported";
      terminal = "kitty";
      providers.desktop_applications.enable = true;
      list = {
        show_scrollbar = false;
      };
      search = {
        placeholder = "";
      };
      close_when_open = true;

      keybinds = {
        accept = [ "Space" ];
        next = [
          "ctrl j"
          "Tab"
        ];
        previous = [
          "ctrl k"
          "ISO_Left_Tab"
        ];
        quick_activate = [
          "F1"
          "F2"
          "F3"
          "F4"
          "F5"
          "F6"
          "F7"
          "F8"
        ];
      };
    };

    themes."wofi-ported" = {
      style = ''
        @define-color accent_bg_color ${themeLib.semantic.accent};
        @define-color theme_fg_color ${themeLib.semantic.fg};
        @define-color inactive_bg_color ${themeLib.semantic.secondary};
        @define-color base_color ${themeLib.semantic.bg};

        /* Window Entrance Animation */
        @keyframes pop-in {
          0% {
            opacity: 0;
            transform: scale(0.95);
          }
          100% {
            opacity: 1;
            transform: scale(1);
          }
        }

        @keyframes pulse-once {
          0% {
            transform: scale(1);
          }
          50% {
            transform: scale(1.1);
          }
          100% {
            transform: scale(1);
          }
        }

        * {
          all: unset;
        }

        .box-wrapper {
          background-image: url('/home/jgirco/Pictures/wallpapers/${theme}.jpg');
          background-size: cover;
          background-repeat: no-repeat;
          background-position: center;
          padding: 20px;
          border-radius: 20px;

          animation: pop-in 0.2s cubic-bezier(0.25, 1, 0.5, 1) forwards;
        }

        .input {
          caret-color: @theme_fg_color;
          background: @base_color;
          border: 2px solid @accent_bg_color;
          padding: 10px 15px;
          color: @theme_fg_color;
          border-radius: 10px;
          margin-bottom: 20px;
          margin-top: 20px;

          /* Smooth border color transition on focus */
          transition: border-color 0.15s ease-in-out;
        }

        .input placeholder {
          opacity: 0.5;
        }

        .list {
          background: transparent;
          /* Add padding so scaled items don't hit the scroll window edges */
          padding: 4px;
        }

        .item-box {
          border-radius: 10px;
          padding: 10px;
          background: @inactive_bg_color;
          /* Replaced margin-bottom with a full margin shorthand: top right bottom left */
          margin: 0px 4px 8px 4px;

          transition: background-color 0.15s ease, transform 0.1s ease;
        }

        scrolledwindow {
          background-color: @base_color;
          border-radius: 20px;
          padding: 20px;
        }

        child:hover .item-box,
        child:selected .item-box {
          background: @accent_bg_color;
          animation: pulse-once 0.2s ease-out;
        }

        .item-text {
          font-size: 20px;
          color: @base_color;
        }

        .item-subtext {
          font-size: 12px;
          opacity: 0.7;
          color: @base_color;
        }

        .item-image, .item-image-text {
          margin-right: 10px;
        }

        .item-quick-activation {
          margin-left: 10px;
          background-color: @base_color;
          color: @theme_fg_color;
          border-radius: 5px;
          padding: 5px 10px;
          font-weight: bold;
        }

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

        .placeholder, .elephant-hint { color: @theme_fg_color; opacity: 0.5; }
        .normal-icons { -gtk-icon-size: 16px; }
        .large-icons { -gtk-icon-size: 32px; }
        scrollbar { opacity: 0; }
      '';
    };
  };
}
