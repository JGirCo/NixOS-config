{ lib, pkgs, theme, browser, colors, inputs, ... }:

let
  terminal = "kitty";

  startupScript = pkgs.writeShellScriptBin "startupScript" ''
    udiskie &
    keyd-application-mapper -d &
    swww-daemon &
    systemctl --user restart pipewire pipewire-pulse &
    waybar &
    dunst &
    mpris-notifier &
    swww img ~/Pictures/wallpapers/${theme}.jpg --transition-type any &
  '';

  prelockScript = pkgs.writeShellScriptBin "prelockScript" ''
    tmpbg="/tmp/screen.png"
    ${pkgs.grim}/bin/grim "$tmpbg"
    ${pkgs.imagemagick}/bin/magick "$tmpbg" -blur 0x5 -fill "#${colors.base}" -colorize 50% "$tmpbg"
  '';

  # Helper for shell commands
  sh = cmd: [ "${pkgs.bash}/bin/sh" "-c" cmd ];

  # Niri scratchpad configuration
  niri-scratchpad = inputs.niri-scratchpad.packages.${pkgs.system}.niri-scratchpad;

in with colors; {
  imports = [ ./waybar.nix ];
  home.packages = with pkgs; [
    mpris-notifier
    swww
    waybar
    dunst
    wofi
    grim
    slurp
    swappy
    imagemagick
    wl-clipboard
    wezterm
    gtklock
    gtklock-powerbar-module
    gtklock-playerctl-module
    gtklock-userinfo-module
    niri-scratchpad
  ];

  services.hypridle = {
    enable = true;
    settings = {
      listener = [
        {
          timeout = 121; # 2 min.
          on-timeout =
            "light -O && light -T 0.5"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "light -I"; # monitor backlight restore.
        }
        {
          timeout = 120; # 2 min
          on-timeout = "${prelockScript}/bin/prelockScript";
        }
        {
          timeout = 300; # 5 min
          on-timeout =
            "niri msg action do-screen-transition --delay-ms 500 && niri msg action power-off-monitors";
          on-resume = "niri msg action power-on-monitors";
        }
        {
          timeout = 600; # 10 min
          on-timeout = ''
            ${pkgs.gtklock}/bin/gtklock -m ${pkgs.gtklock-powerbar-module}/lib/gtklock/powerbar-module.so -m ${pkgs.gtklock-playerctl-module}/lib/gtklock/playerctl-module.so -b "/tmp/screen.png"'';
        }
        {
          timeout = 1200; # 20 min
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  programs.niri = {
    enable = true;
    settings = {
      spawn-at-startup =
        [{ command = [ "${startupScript}/bin/startupScript" ]; }];
      input = {
        keyboard.xkb.layout = "latam";
        touchpad.natural-scroll = true;
      };
      outputs = { "eDP-1".scale = 1.0; };
      
      # Define workspaces including scratch workspace
      workspaces = {
        "1" = {};
        "2" = {};
        "3" = {};
        "4" = {};
        "5" = {};
        "6" = {};
        "7" = {};
        "8" = {};
        "9" = {};
        "scratch" = {};
      };
      
      layout = {

        gaps = 16;
        center-focused-column = "never";

        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 2.0 / 3.0; }
        ];

        default-column-width = { proportion = 0.5; };

        focus-ring = {
          enable = true;
          width = 8;
          active.gradient = {
            angle = 45;
            from = "${focused}";
            to = "${alt}";
            relative-to = "workspace-view";
          };
        };
      };

      prefer-no-csd = true;

      window-rules = [
        {
          matches = [ { } ];
          geometry-corner-radius = {
            top-left = 12.0;
            top-right = 12.0;
            bottom-left = 12.0;
            bottom-right = 12.0;
          };
          clip-to-geometry = true;
          draw-border-with-background = false;
        }
        {
          matches = [{ app-id = "^${terminal}$"; }];
          opacity = 0.9;
        }
        # Scratchpad window rules
        {
          matches = [{ app-id = "^\\.blueman-manager-wrapped$"; }];
          open-on-workspace = "scratch";
          open-floating = true;
        }
        {
          matches = [{ app-id = "^kitty$"; title = ".*wiremix.*"; }];
          open-on-workspace = "scratch";
          open-floating = true;
        }
        {
          matches = [{ app-id = "^zen-twilight$"; title = ".*WhatsApp.*"; }];
          open-on-workspace = "scratch";
          open-floating = true;
        }
      ];

      binds = let
        # Helper to generate workspace binds
        workspaces = builtins.listToAttrs (builtins.concatLists
          (builtins.genList (i:
            let
              ws = i + 1;
              key = toString ws;
            in [
              {
                name = "Mod+${key}";
                value.action.focus-workspace = ws;
              }
              {
                name = "Mod+Shift+${key}";
                value.action.move-window-to-workspace = ws;
              }
            ]) 9));
      in workspaces // {
        # Applications
        "Mod+T".action.spawn = "${terminal}";
        "Mod+B".action.spawn = "${browser.name}";
        "Mod+D".action.spawn = sh "pkill wofi || wofi --show drun";

        # Scratchpad keybindings
        "Mod5+B".action.spawn = sh "nscratch -id .blueman-manager-wrapped -s blueman-manager";
        "Mod5+V".action.spawn = sh "nscratch -t wiremix -s 'kitty -e wiremix'";
        "Mod5+W".action.spawn = sh "nscratch -t '.*WhatsApp.*Zen Twilight' -s '${browser.name} --new-window web.whatsapp.com -P Whatsapp'";

        # Window Management
        "Mod+Q".action.close-window = [ ];
        "Mod+F".action.fullscreen-window = [ ];
        "Mod+O".action.toggle-overview = [ ];

        # Focus
        "Mod+H".action.focus-column-left = [ ];
        "Mod+L".action.focus-column-right = [ ];
        "Mod+K".action.focus-window-or-workspace-up = [ ];
        "Mod+J".action.focus-window-or-workspace-down = [ ];

        # Move
        "Mod+Shift+H".action.move-column-left = [ ];
        "Mod+Shift+L".action.move-column-right = [ ];
        "Mod+Shift+K".action.move-window-up-or-to-workspace-up = [ ];
        "Mod+Shift+J".action.move-window-down-or-to-workspace-down = [ ];

        # Stacking (Vertical Tiling)
        "Mod+V".action.consume-or-expel-window-left = [ ];
        "Mod+BracketLeft".action.consume-or-expel-window-left = [ ];
        "Mod+BracketRight".action.consume-or-expel-window-right = [ ];

        # Resize
        "Mod+R".action.switch-preset-column-width = [ ];
        "Mod+Alt+H".action.set-column-width = "-10%";
        "Mod+Alt+L".action.set-column-width = "+10%";
        "Mod+Alt+K".action.set-window-height = "-10%";
        "Mod+Alt+J".action.set-window-height = "+10%";

        # Niri Specifics - Column Operations
        "Mod+C".action.center-column = [ ];
        "Mod+M".action.maximize-column = [ ];
        "Mod+Shift+M".action.reset-window-height = [ ];
        "Mod+Home".action.focus-column-first = [ ];
        "Mod+End".action.focus-column-last = [ ];
        "Mod+Slash".action.show-hotkey-overlay = [ ];

        # Workspace Navigation (Vertical)
        "Mod+U".action.focus-workspace-down = [ ];
        "Mod+I".action.focus-workspace-up = [ ];
        "Mod+WheelScrollDown".action.focus-workspace-down = [ ];
        "Mod+WheelScrollUp".action.focus-workspace-up = [ ];

        # Workspace Movement
        "Mod+Ctrl+U".action.move-workspace-down = [ ];
        "Mod+Ctrl+I".action.move-workspace-up = [ ];

        # Move Column to Workspace
        "Mod+Shift+U".action.move-column-to-workspace-down = [ ];
        "Mod+Shift+I".action.move-column-to-workspace-up = [ ];
        "Mod+Shift+WheelScrollDown".action.move-column-to-workspace-down = [ ];
        "Mod+Shift+WheelScrollUp".action.move-column-to-workspace-up = [ ];

        # Screenshots
        "Print".action.spawn =
          sh ''grim -g "$(slurp)" - | convert - -shave 1x1 PNG: - | wl-copy'';
        "Shift+Print".action.spawn = sh ''grim -g "$(slurp)" - | swappy -f -'';

        # Volume and Media
        "XF86AudioRaiseVolume".action.spawn =
          sh "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume".action.spawn =
          sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute".action.spawn =
          sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute".action.spawn =
          sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        "XF86MonBrightnessUp".action.spawn = sh "light -A 5";
        "XF86MonBrightnessDown".action.spawn = sh "light -U 5";

        "XF86AudioNext".action.spawn = sh "playerctl next";
        "XF86AudioPause".action.spawn = sh "playerctl play-pause";
        "XF86AudioPlay".action.spawn = sh "playerctl play-pause";
        "XF86AudioPrev".action.spawn = sh "playerctl previous";

        # Workspace 10
        "Mod+0".action.focus-workspace = 10;
        "Mod+Shift+0".action.move-window-to-workspace = 10;
      };
    };
  };
}

