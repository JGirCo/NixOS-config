{
  lib,
  config,
  theme,
  pkgs,
  ...
}:

let
  cfg = config.programs.noctalia;
in
{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    # Initial configuration. Override at runtime via the Settings UI.
    settings = {
      # Theme — colors are typically driven by stylix.
      theme = {
        mode = "dark";
        source = "stylix";
      };

      # Fonts match the stylix fonts config.
      shell = {
        font = "Maple Mono NF";
      };

      # Notifications (replaces swaync).
      notifications = {
        enabled = true;
        # Position the notification panel similarly to the previous swaync setup.
        anchor = "top-right";
      };

      # Wallpaper — Noctalia picks this from stylix palette by default.
      wallpaper = {
        enabled = true;
        # When set, the theme Switcher script should call
        #   noctalia msg wallpaper set-next
        # to advance; stylix colors are consumed via theme.source = "stylix".
      };

      # OSD (replaces swayosd).
      osd = {
        enabled = true;
      };

      # Idle / lock — kept minimal; full integration is via noctalia lockscreen.
      lockscreen = {
        enabled = true;
        lock_before_suspend = true;
      };
    };
  };
}
