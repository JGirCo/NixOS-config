{ config, lib, pkgs, theme, font, ... }:

let
  mod = "SUPER";
  up = "k";
  down = "j";
  left = "h";
  right = "l";

  startupScript = pkgs.pkgs.writeShellScriptBin "startupScript" ''
    pkill swww
    sleep 1
    swww-daemon &
    sleep 1
    swww img ~/Pictures/wallpapers/${theme}.jpg &
    waybar &
  '';

  colors = import ../colors.nix {
    inherit theme;
    inherit lib;
  };

in with colors; {
  imports = [ ./waybar.nix ];
  home.packages = with pkgs; [
    swww
    waybar
    kitty
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
      exec-once = "${startupScript}/bin/startupScript";
      exec = "swww img ~/Pictures/wallpapers/${theme}.jpg --transition-type any";
      "$mod" = "SUPER";
      general = {
        border_size = 4;
        gaps_in = 4;
        gaps_out = 10;
        "col.active_border" = "rgb(${focused}) rgb(${alt}) 45deg";
        "col.inactive_border" = "rgba(${inactive}44)";
      };
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, light -A 5"
        ",XF86MonBrightnessDown, exec, light -U 5"
      ];

      bindl = [
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPause, exec, playerctl play-pause"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioPrev, exec, playerctl previous"
      ];
      input = {
        # name = "keyboard";
        kb_layout = "latam";
        touchpad = { natural_scroll = true; };
      };

      decoration = {
        rounding = 10;
        shadow.enabled = false;

        blur = {
          enabled = true;
          size = 10;
          passes = 2;
          noise = 0.0;
        };
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
      windowrule = [

        "opacity 0.77,^(kitty)$"
      ];
      monitor = "eDP-1,preferred,auto,1";
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
        "$mod, T, exec, kitty"
        "$mod, Q, killactive"
        "$mod, B, exec, floorp"
        "$mod, D, exec, wofi --show drun"
        "$mod, R, exec, rofi -show drun"

        "$mod, ${left}, movefocus, l"
        "$mod, ${right}, movefocus, r"
        "$mod, ${up}, movefocus, u"
        "$mod, ${down}, movefocus, d"

        "$mod SHIFT, ${left}, movewindow, l"
        "$mod SHIFT, ${right}, movewindow, r"
        "$mod SHIFT, ${up}, movewindow, u"
        "$mod SHIFT, ${down}, movewindow, d"

      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]) 9));

    };
  };
}
