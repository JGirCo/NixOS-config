{
  lib,
  theme,
  font,
  pkgs,
  config,
  colors,
  ...
}:
with colors;
with config.colorScheme.palette;
{
  home.packages = [ pkgs.libnotify ]; # to enable notify-send
  services.swaync = {
    enable = true;
    settings = {
      "$schema" = "/etc/xdg/swaync/configSchema.json";

      positionX = "right";
      positionY = "top";
      control-center-margin-top = 20;
      control-center-margin-bottom = 0;
      control-center-margin-right = 20;
      control-center-margin-left = 0;
      control-center-width = 500;
      control-center-height = 600;
      fit-to-screen = false;

      layer = "top";
      cssPriority = "user";
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      notification-window-width = 500;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = true;
      hide-on-action = true;
      script-fail-notify = true;

      widgets = [
        "title"
        "dnd"
        "mpris"
        "notifications"
      ];
      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
        label = {
          max-lines = 5;
          text = "Label Text";
        };
        mpris = {
          image-size = 96;
          image-radius = 12;
        };
      };
    };
    style = ''
      /* Dracula Theme Colors */
      @define-color foreground #${text2};
      @define-color background #${base};
      @define-color background-alpha #${base};
      @define-color accent #${focused};
      @define-color current-line #${base};
      @define-color comment #${base03};
      @define-color urgent #${urgent};

      /* --- Notification Containers --- */

      .notification-row {
        margin-bottom: 4px;
        margin-right: 13px;
        margin-top: 8px;
        border-radius: 8px;
      }

      .notification {
        background: transparent;
        border-radius: 8px;
        margin: 12px 7px 0px 7px;
        box-shadow: none;
        padding: 0;
      }

      .notification-content {
        background: transparent;
        padding: 6px;
        border-radius: 8px;
      }

      .low, .normal {
        background: @background;
        color: @foreground;
        padding: 6px;
        border-radius: 12px;
      }

      .critical {
        background: @urgent;
        color: @background;
        padding: 6px;
        border-radius: 12px;
      }

      .notification-row {
          background: transparent;
          color: @focused;
      }
      .summary {
        color: #${focused};
        font-size: 16px;
        font-weight: bold;
        background: transparent;
      }

      .body {
        font-size: 15px;
        font-weight: normal;
        background: transparent;
        color: @foreground;
      }

      /* --- Critical Text Overrides (Ensure high contrast) --- */

      .critical .summary {
          color: @background;
          background: transparent;
      }

      .critical .body {
          color: @background;
          background: transparent;
      }
    '';
  };
}
