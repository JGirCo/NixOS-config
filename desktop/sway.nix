{ config, lib, pkgs, theme, font, ... }:

let
  mod = "Mod4";
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

  # base = "#${config.colorScheme.palette.base00}";
  # text = "#${config.colorScheme.palette.base00}";
  # inactive = "#${config.colorScheme.palette.base03}";
  # focused = "#${config.colorScheme.palette.base09}";
  # active = "#${config.colorScheme.palette.base0A}";
  # urgent = "#${config.colorScheme.palette.base08}";
  # binding = "#${config.colorScheme.palette.base0E}";
in with colors; {
  imports = [ ./waybar.nix ];
  home.packages = with pkgs; [
    # swaybg
    # wbg # The only one that works consistently...
    swww
    waybar
    dunst
    wofi
    swayfx
    grim
    slurp
    imagemagick
    swappy
    wl-clipboard
  ];
  # wayland.windowManager.swayfx.enable = true;
  wayland.windowManager.sway = {
    enable = true;
    checkConfig = false;
    package = pkgs.swayfx;
    extraConfig = ''
      for_window [class = "^Emacs$"] opacity 0.85
      for_window [app_id = "^org.wezfurlong.wezterm"] opacity 0.75
      blur enable
      blur_radius 2
      corner_radius 10
    '';
    config = {
      terminal = "wezterm";
      modifier = mod;
      defaultWorkspace = "workspace number 1";
      workspaceAutoBackAndForth = true;

      input = {
        "*" = {
          xkb_layout = "latam";
          tap = "enabled";
          natural_scroll = "enabled";
        };
        "5215:711:Trust_Wireless_Mouse" = { natural_scroll = "disabled"; };
      };

      assigns = { "10" = [{ class = "^Spotify$"; }]; };

      fonts = {
        names = [ "${font} Nerd Font" ];
        size = 9.0;
      };
      startup = [
        {
          command = "swww-daemon";
          always = true;
        }
        {
          command =
            "${pkgs.swww}/bin/swww img ~/Pictures/wallpapers/${theme}.jpg";
          always = true;
        }
        {
          command = "--no-startup-id ${pkgs.waybar}/bin/waybar";
          always = true;
        }
        {
          command =
            "--no-startup-id systemctl --user restart nm-applet.service";
          always = true;
        }
      ];
      window = {
        border = 4;
        titlebar = false;
      };
      gaps.inner = 5;

      focus.followMouse = false;

      keybindings = lib.mkOptionDefault {
        "${mod}+q" = "kill";
        "${mod}+b" = "exec floorp";
        "${mod}+d" = "exec wofi --show drun";
        "${mod}+t" = "exec wezterm";
        "${mod}+m" = "exec emacsclient -r";
        "${mod}+s" = "exec wezterm start spt;exec spotifyd";
        "Print" = ''
          exec grim -g "$(slurp)" - | convert -  -shave 1x1 PNG: - | wl-copy'';
        "Shift+Print" = ''exec grim -g "$(slurp)" - | swappy -f -'';

        # Focus
        "${mod}+${left}" = "focus left";
        "${mod}+${down}" = "focus down";
        "${mod}+${up}" = "focus up";
        "${mod}+${right}" = "focus right";

        # Move
        "${mod}+Shift+${left}" = "move left";
        "${mod}+Shift+${down}" = "move down";
        "${mod}+Shift+${up}" = "move up";
        "${mod}+Shift+${right}" = "move right";

        # split
        "${mod}+c" = "split h";
        "${mod}+v" = "split v";

        # fullscreen
        "${mod}+f" = "fullscreen toggle";

        # Other
        "${mod}+e" = "layout toggle split";
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";
        "${mod}+a" = "focus parent";

        "${mod}+Shift+c" = "reload";

        "${mod}+Shift+1" = "move container to workspace 1; workspace 1";
        "${mod}+Shift+2" = "move container to workspace 2; workspace 2";
        "${mod}+Shift+3" = "move container to workspace 3; workspace 3";
        "${mod}+Shift+4" = "move container to workspace 4; workspace 4";
        "${mod}+Shift+5" = "move container to workspace 5; workspace 5";
        "${mod}+Shift+6" = "move container to workspace 6; workspace 6";
        "${mod}+Shift+7" = "move container to workspace 7; workspace 7";
        "${mod}+Shift+8" = "move container to workspace 8; workspace 8";
        "${mod}+Shift+9" = "move container to workspace 9; workspace 9";
        "${mod}+Shift+0" = "move container to workspace 10";

        "XF86AudioRaiseVolume" =
          "exec --no-startup-id pamixer -i 5 && pkill -RTMIN+12 i3blocks";
        "XF86AudioLowerVolume" =
          "exec --no-startup-id pamixer -d 5 && pkill -RTMIN+12 i3blocks ";
        "XF86AudioMute" =
          "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && pkill -RTMIN+12 i3blocks";
        "XF86AudioMicMute" =
          "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status";
        "XF86MonBrightnessUp" = "exec light -A 5 && pkill -RTMIN+15 i3blocks";
        "XF86MonBrightnessDown" =
          "exec light -U 5 && pkill -SIGRTMIN+15 i3blocks";
      };
      modes = {
        resize = {
          Down = "resize grow height 10 px";
          Escape = "mode default";
          Left = "resize shrink width 10 px";
          Return = "mode default";
          Right = "resize grow width 10 px";
          Up = "resize shrink height 10 px";
          h = "resize shrink width 10 px";
          j = "resize grow height 10 px";
          k = "resize shrink height 10 px";
          l = "resize grow width 10 px";
        };
      };

      bars = [ ];
      colors = {
        focused = {
          background = focused;
          border = focused;
          childBorder = focused;
          indicator = focused;
          text = base;
        };
        unfocused = {
          background = unfocused;
          border = unfocused;
          childBorder = unfocused;
          indicator = unfocused;
          text = base;
        };
        focusedInactive = {
          background = focused_inactive;
          border = focused_inactive;
          childBorder = focused_inactive;
          indicator = focused_inactive;
          text = base;
        };
        urgent = {
          background = urgent;
          border = urgent;
          childBorder = urgent;
          indicator = urgent;
          text = urgent;
        };
      };
    };
  };
}
