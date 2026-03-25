{
  lib,
  pkgs,
  theme,
  browser,
  colors,
  ...
}:

let
  up = "k";
  down = "j";
  left = "h";
  right = "l";
  monitorHeight = 1600;
  monitorWidth = 2560;
  terminal = "kitty";

  startupScript = pkgs.writeShellScriptBin "startupScript" ''
    udiskie &
    keyd-application-mapper -d &
    swww-daemon &
    kdeconnectd &
    # legion-kb-rgb set -e Static -c 100,100,100,100,100,100,100,100,100,100,100,100
    systemctl --user restart pipewire pipewire-pulse &
  '';

  reloadScript = pkgs.writeShellScriptBin "reloadScript" ''
    pkill waybar &
    sleep 0.2
    swww img ~/Pictures/wallpapers/${theme}.jpg --transition-type any &
    waybar & disown
  '';

  prelockScript = pkgs.writeShellScriptBin "prelockScript" ''
    tmpbg="/tmp/screen.png"
    ${pkgs.grim}/bin/grim "$tmpbg"
    ${pkgs.imagemagick}/bin/magick "$tmpbg" -blur 0x5 -fill "#${colors.base}" -colorize 50% "$tmpbg"
  '';

  scratch-program =
    {
      name,
      command,
      key,
      title,
    }:
    {
      keybind = "MOD5, ${key}, togglespecialworkspace, ${name}";
      winrule = "match:title ^(${title})(.*)$, min_size ${
        builtins.toString (builtins.floor (monitorWidth * 0.75))
      } ${builtins.toString (builtins.floor (monitorHeight * 0.75))}";

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
      command = "kitty -e wiremix";
      title = "wiremix";
    })

    (scratch-program {
      name = "whatsapp";
      key = "W";
      command = "${browser.name} --new-window web.whatsapp.com -P Whatsapp";
      title = "WhatsApp";
    })
  ];

in
with colors;
{
  imports = [ ./waybar.nix ];
  home.packages = with pkgs; [
    mpris-notifier
    swww
    waybar
    swaynotificationcenter
    wofi
    grim
    slurp
    swappy
    imagemagick
    wl-clipboard
    wezterm
    gtklock-powerbar-module
    gtklock-playerctl-module
    gtklock-userinfo-module
    brightnessctl
  ];
  services.hypridle = {
    enable = true;
    settings = {
      listener = [
        {
          timeout = 300; # 5 min
          on-timeout = "${prelockScript}/bin/prelockScript";
        }
        {
          timeout = 120; # 2 min.
          on-timeout = "brightnessctl -s; brightnessctl set $(( $(brightnessctl get) / 2 ))"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "brightnessctl -r"; # monitor backlight restore.
        }
        {
          timeout = 360; # 6 min.
          on-timeout = "brightnessctl -s; brightnessctl -n"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "brightnessctl -r"; # monitor backlight restore.
        }
        {
          timeout = 600; # 10 min
          on-timeout = ''${pkgs.gtklock}/bin/gtklock -m ${pkgs.gtklock-powerbar-module}/lib/gtklock/powerbar-module.so -m ${pkgs.gtklock-playerctl-module}/lib/gtklock/playerctl-module.so -b "/tmp/screen.png"'';
        }
        {
          timeout = 1200; # 20 min
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      misc.disable_hyprland_logo = true;
      exec-once = "${startupScript}/bin/startupScript";
      exec = "${reloadScript}/bin/reloadScript";
      "$mod" = "SUPER";
      general = {
        border_size = 8;
        gaps_in = 3;
        gaps_out = 6;
        "col.active_border" = " rgb(${focused}) rgb(${focused}) rgb(${base}) rgb(${alt}) rgb(${alt}) 45deg";
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
        ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
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
        touchpad = {
          natural_scroll = true;
        };
        follow_mouse = 2;
      };

      decoration = {
        rounding = 10;
        shadow.enabled = false;

        blur = {
          xray = true;
          enabled = true;
          size = 9;
          passes = 2;
          noise = 1.0e-2;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "myBezier, 0.25, 0.9, 0.1, 1.01"
          "bounce, 0.34, 1.36, 0.64, 1"
        ];
        animation = [
          "windows, 1, 7, myBezier"
          "windowsMove, 1, 5, myBezier"
          "windowsOut, 1, 5, default, popin 10%"
          "windowsIn, 1, 5, bounce"
          "border, 1, 7, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 5, bounce"
        ];
      };
      windowrule = [
        "match:class ^wofi$, animation slide"
        "match:class ^wofi$, stay_focused true"
        "match:class .*${terminal}.*, opacity 0.75"
      ]
      ++ map (app: app.winrule) scratch-apps;

      workspace = [ ] ++ map (app: app.workspace) scratch-apps;

      monitor = [
        "eDP-1,preferred,auto,1"
        "eDP-2,preferred,auto,1"
      ];
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
        "$mod, B, exec, ${browser.name}"
        "$mod, R, exec, rofi -show drun"

        "$mod, ${left}, movefocus, l"
        "$mod, ${right}, movefocus, r"
        "$mod, ${up}, movefocus, u"
        "$mod, ${down}, movefocus, d"

        "$mod SHIFT, ${left}, movewindow, l"
        "$mod SHIFT, ${right}, movewindow, r"
        "$mod SHIFT, ${up}, movewindow, u"
        "$mod SHIFT, ${down}, movewindow, d"
        "$mod, S, togglesplit"
        '', PRINT, exec, grim -g "$(slurp)" - | convert -  -shave 1x1 PNG: - | wl-copy''
        ''SHIFT, PRINT, exec, grim -g "$(slurp)" - | swappy -f -''

        "$mod, 0, workspace, 10"
        "$mod SHIFT, 0, movetoworkspacesilent, 10"

      ]
      ++ (
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        )
      )
      ++ map (app: app.keybind) scratch-apps;
    };
  };
}
