{ config, lib, pkgs, theme, font, ... }:

let
  mod = "SUPER";
  up = "k";
  down = "j";
  left = "h";
  right = "l";
  monitorHeight = 1080;
  monitorWidth = 1920;
  terminal = "kitty";

  startupScript = pkgs.pkgs.writeShellScriptBin "startupScript" ''
    pkill swww
    sleep 1
    swww-daemon &
    sleep 1
    swww img ~/Pictures/wallpapers/${theme}.jpg &
    waybar &
    systemctl --user restart pipewire pipewire-pulse &
  '';

  colors = import ../colors.nix {
    inherit theme;
    inherit lib;

  };
  scratch-program = { name, command, key, title }: {
    keybind = "MOD5, ${key}, togglespecialworkspace, ${name}";
    winrule =
      "minsize ${builtins.toString (builtins.floor (monitorWidth * 0.75))} ${
        builtins.toString (builtins.floor (monitorHeight * 0.75))
      },title:(${title})(.*)";

    workspace = "special:${name},on-created-empty:[float] ${command}";
  };

  scratch-apps = [
    (scratch-program {
      name = "bluetooth";
      key = "B";
      command = "blueman-manager";
      title = "Bluetooth Devices";
    })

    (scratch-program {
      name = "volume";
      key = "V";
      command = "pavucontrol";
      title = "Volume Control";
    })

    (scratch-program {
      name = "whatsapp";
      key = "W";
      command = "floorp --new-window web.whatsapp.com -P Whatsapp";
      title = "WhatsApp";
    })
  ];

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
      exec =
        "swww img ~/Pictures/wallpapers/${theme}.jpg --transition-type any";
      "$mod" = "SUPER";
      general = {
        border_size = 5;
        gaps_in = 3;
        gaps_out = 10;
        "col.active_border" =
          " rgb(${focused}) rgb(${focused}) rgb(${base}) rgb(${alt}) rgb(${alt}) 45deg";
        # "col.active_border" =
        #   "rgba(${red}FF) rgba(${yellow}FF) rgba(${yellow}FF) rgba(${green}FF) rgba(${green}FF) rgba(${blue}FF) rgba(${blue}FF) rgba(${purple}FF) 30deg";
        "col.inactive_border" = "rgba(${inactive}00)";
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

        "noborder on,^(wofi)$"
        "animation slide,^(wofi)$"
      ];

      windowrulev2 = [ "opacity 0.77,initialTitle:^(${terminal})$" ]
        ++ map (app: app.winrule) scratch-apps;

      workspace = [ ] ++ map (app: app.workspace) scratch-apps;

      monitor = "eDP-1,preferred,auto,1";
      dwindle = {
        pseudotile = true;
        preserve_split = true; # you probably want this
        force_split = 2;
      };

      # bindr = [ "$mod, SUPER_L,exec,pkill wofi || wofi --show drun" ];
      binde = [
        "$mod ALT, ${right}, resizeactive, 10 0"
        "$mod ALT, ${left}, resizeactive, -10 0"
        "$mod ALT, ${up}, resizeactive, 0 -10"
        "$mod ALT, ${down}, resizeactive, 0 10"
      ];

      bind = [
        "$mod, D ,exec,pkill wofi || wofi --show drun"
        "$mod, T, exec, ${terminal}"
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod, B, exec, floorp"
        "$mod, R, exec, rofi -show drun"

        "$mod, ${left}, movefocus, l"
        "$mod, ${right}, movefocus, r"
        "$mod, ${up}, movefocus, u"
        "$mod, ${down}, movefocus, d"

        "$mod SHIFT, ${left}, movewindow, l"
        "$mod SHIFT, ${right}, movewindow, r"
        "$mod SHIFT, ${up}, movewindow, u"
        "$mod SHIFT, ${down}, movewindow, d"

        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        ''
          , PRINT, exec, grim -g "$(slurp)" - | convert -  -shave 1x1 PNG: - | wl-copy''

      ] ++ (
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]) 9)) ++ map (app: app.keybind) scratch-apps;
    };
  };
}
