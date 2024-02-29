{ config, lib, pkgs, theme, ... }:

let
  mod = "Mod4";
  up = "k";
  down = "j";
  left = "h";
  right = "l";

  unfocused = "#ffffff00";
  focused_inactive = "#ffffff00";
  colorScheme = import ./colors.nix;

  # base = "#${config.colorScheme.palette.base00}";
  # text = "#${config.colorScheme.palette.base00}";
  # inactive = "#${config.colorScheme.palette.base03}";
  # focused = "#${config.colorScheme.palette.base09}";
  # active = "#${config.colorScheme.palette.base0A}";
  # urgent = "#${config.colorScheme.palette.base08}";
  # binding = "#${config.colorScheme.palette.base0E}";
in
with colorScheme."${theme}";
{
    imports = [
      ./waybar.nix
    ];
    home.packages = with pkgs; [
      swww
      waybar
      dunst
      rofi
    ];
    wayland.windowManager.sway = {
      enable = true;
      extraConfig = ''
        for_window [class = "^Emacs$"] opacity 0.85
        for_window [app_id = "^org.wezfurlong.wezterm"] opacity 0.85
        '';
      config = {
        modifier = mod;
        defaultWorkspace = "workspace 1: Main";
        workspaceAutoBackAndForth = true;

          input = {
            "*" = {
              xkb_layout = "latam";
              tap = "enabled";
              natural_scroll = "enabled";
            };

        };

        assigns = {"10: Background" = [{class = "^Spotify$";}];};

        fonts = { names = [ "FantasqueSansM Nerd Font" ]; size = 9.0; };
        startup = [
          { command = "--no-startup-id swww init"; always = true; }
          { command = "--no-startup-id swww img ~/Pictures/wallpapers/${theme}.jpg"; always = true; }
        #     command = "${pkgs.waybar}/bin/waybar";
          { command = "--no-startup-id ${pkgs.waybar}/bin/waybar"; always = true; }
          { command = "--no-startup-id nm-applet"; always = true; }
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
          "${mod}+d" = "exec rofi -modi drun -show drun -config ~/.config/rofi/rofidmenu.rasi";
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

          "${mod}+Shift+1" = "move container to workspace 1: Main; workspace 1: Main";
          "${mod}+Shift+2" = "move container to workspace 2; workspace 2";
          "${mod}+Shift+3" = "move container to workspace 3; workspace 3";
          "${mod}+Shift+4" = "move container to workspace 4; workspace 4";
          "${mod}+Shift+5" = "move container to workspace 5; workspace 5";
          "${mod}+Shift+6" = "move container to workspace 6; workspace 6";
          "${mod}+Shift+7" = "move container to workspace 7; workspace 7";
          "${mod}+Shift+8" = "move container to workspace 8; workspace 8";
          "${mod}+Shift+9" = "move container to workspace 9; workspace 9";
          "${mod}+Shift+0" = "move container to workspace 10: Background; workspace 10: Background";

          "XF86AudioRaiseVolume" = "exec --no-startup-id pamixer -i 5 && pkill -RTMIN+12 i3blocks";
          "XF86AudioLowerVolume" = "exec --no-startup-id pamixer -d 5 && pkill -RTMIN+12 i3blocks ";
          "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && pkill -RTMIN+12 i3blocks";
          "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status";
          "XF86MonBrightnessUp" = "exec light -A 5 && pkill -RTMIN+15 i3blocks";
          "XF86MonBrightnessDown" = "exec light -U 5 && pkill -SIGRTMIN+15 i3blocks";
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

        bars = [
        ];
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
