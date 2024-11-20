{ config, lib, pkgs, theme, font, ... }:

let
  mod = "SUPER";
  up = "k";
  down = "j";
  left = "h";
  right = "l";

  unfocused = "#ffffff00";
  focused_inactive = "#ffffff00";
  colors = import ../colors.nix {
    inherit theme;
    inherit lib;
  };

in with colors; {
  imports = [ ./waybar.nix ];
  home.packages = with pkgs; [
    wbg # The only one that works consistently...
    waybar
    dunst
    wofi
    swayfx
    grim
    slurp
    imagemagick
    swappy
    wl-clipboard
    wezterm
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      general = {
        border_size = 4;
        gaps_in = 4;
        "col.active_border" = focused;
      };
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
      input = {
        # name = "keyboard";
        kb_layout = "latam";
        touchpad = { natural_scroll = true; };
      };

      decoration = {
        rounding = 10;
        drop_shadow = false;
      };

      animations = {
        enabled = true;

        bezier = "myBezier, 0.25, 0.9, 0.1, 1.02";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsMove, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
        ];
      };
      #
      # dwindle = {
      #   # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      #   pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      #   preserve_split = true; # you probably want this
      # };
      #
      # master = {
      #   # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      #   new_is_master = true;
      #   # soon :)
      #   # orientation = "center";
      # };
      #
      # gestures = {
      #   # See https://wiki.hyprland.org/Configuring/Variables/ for more
      #   workspace_swipe = false;
      # };

      bind = [
        "$mod, T, exec, wezterm"
        "$mod, Q, killactive"
        "$mod, B, exec, firefox"
      ];
    };
  };
}
