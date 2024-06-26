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
in with colors; {

  imports = [ ./picom.nix ];
  home.packages = with pkgs; [
    rofi
    i3blocks
    i3lock
    picom
    flameshot
    feh
    dunst
    lxappearance
  ];
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;
      defaultWorkspace = "workspace number 1";
      workspaceAutoBackAndForth = true;

      assigns = { "10: background" = [{ class = "^spotify$"; }]; };

      fonts = {
        names = [ "${font} Nerd Font" ];
        size = 9.0;
      };
      startup = [
        { command = "--no-startup-id dex --autostart --environment i3"; }
        {
          command =
            "--no-startup-id feh --bg-scale ~/Pictures/wallpapers/${theme}.jpg";
          always = true;
        }
        {
          command =
            "--no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork";
        }
        { command = "--no-startup-id nm-applet"; }
        { command = "--no-startup-id picom -CGb"; }
      ];
      window = {
        border = 3;
        titlebar = false;
      };
      gaps.inner = 5;

      focus.followMouse = false;

      keybindings = lib.mkOptionDefault {
        "${mod}+q" = "kill";
        "${mod}+b" = "exec floorp";
        "${mod}+d" =
          "exec rofi -modi drun -show drun -config ~/.config/rofi/rofidmenu.rasi";
        "${mod}+t" = "exec wezterm";
        "${mod}+m" = "exec emacsclient -r";
        "${mod}+s" = "exec wezterm start spt;exec spotify";
        "Print" = "exec flameshot gui";

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

        "${mod}+Shift+1" =
          "move container to workspace number 1; workspace number 1";
        "${mod}+Shift+2" =
          "move container to workspace number 2; workspace number 2";
        "${mod}+Shift+3" =
          "move container to workspace number 3; workspace number 3";
        "${mod}+Shift+4" =
          "move container to workspace number 4; workspace number 4";
        "${mod}+Shift+5" =
          "move container to workspace number 5; workspace number 5";
        "${mod}+Shift+6" =
          "move container to workspace number 6; workspace number 6";
        "${mod}+Shift+7" =
          "move container to workspace number 7; workspace number 7";
        "${mod}+Shift+8" =
          "move container to workspace number 8; workspace number 8";
        "${mod}+Shift+9" =
          "move container to workspace number 9; workspace number 9";
        "${mod}+Shift+10" =
          "move container to workspace number 10; workspace number 10";

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

      bars = [{
        fonts = {
          names = [ "${font} Nerd Font" ];
          size = 9.0;
        };
        position = "bottom";
        statusCommand =
          "SCRIPT_DIR=~/.config/i3blocks ${pkgs.i3blocks}/bin/i3blocks -c ~/.config/i3blocks/${theme}";
        colors = {
          background = "${base}ff";
          separator = text;
          bindingMode = {
            background = binding;
            border = binding;
            text = base;
          };
          focusedWorkspace = {
            background = focused;
            border = focused;
            text = base;
          };
          inactiveWorkspace = {
            background = inactive;
            border = inactive;
            text = text;
          };
          urgentWorkspace = {
            background = urgent;
            border = urgent;
            text = base;
          };
        };
      }];
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
