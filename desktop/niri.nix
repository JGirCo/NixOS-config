{
  pkgs,
  lib,
  config,
  theme,
  browser,
  colors,
  ...
}:

let
  themeLib = import ../lib/theme.nix {
    inherit config lib colors;
  };

  terminal = "kitty";

  reloadScript = pkgs.writeShellScriptBin "reloadScript" ''
    niri msg action load-config-file
    sleep 0.2
    systemctl --user restart swayosd.service
    awww img ~/Pictures/wallpapers/${theme}.jpg --transition-type any
  '';

  prelockScript = pkgs.writeShellScriptBin "prelockScript" ''
    tmpbg="/tmp/screen.png"
    ${pkgs.grim}/bin/grim "$tmpbg"
    ${pkgs.imagemagick}/bin/magick "$tmpbg" -blur 0x5 -fill "${themeLib.semantic.bg}" -colorize 50% "$tmpbg"
  '';

  # Helper for shell commands
  sh = cmd: [
    "${pkgs.bash}/bin/bash"
    "-c"
    cmd
  ];

  # ── Bind helpers ──────────────────────────────────────────────────────
  # Each helper returns a single-key attrset ready to merge into `binds`.

  # A bare keybind that calls a no-arg action (e.g. close-window, focus-column-left).
  bindNoArg =
    combo: action:
    {
      "${combo}".action.${action} = [ ];
    };

  # A bare keybind that takes a value (e.g. set-column-width, focus-workspace).
  bindWithArg =
    combo: action: value:
    {
      "${combo}".action.${action} = value;
    };

  # Convenience wrappers for the common Mod+ / Mod+Shift+ / Mod+Alt+ / Mod+Ctrl+ prefixes.
  mod = key: action: bindNoArg "Mod+${key}" action;
  modShift = key: action: bindNoArg "Mod+Shift+${key}" action;
  modAlt = key: action: value: bindWithArg "Mod+Alt+${key}" action value;
  modCtrl = key: action: bindNoArg "Mod+Ctrl+${key}" action;

  # Swayosd-driven OSD binds (volume / brightness).
  swayosd =
    {
      combo,
      flag,
      extra ? "",
    }:
    {
      "${combo}".action.spawn = sh "swayosd-client --${flag} ${extra}";
    };

  # playerctl binds.
  mediaKey = combo: cmd: {
    "${combo}".action.spawn = sh "playerctl ${cmd}";
  };

  # Build the 1..10 workspace focus + 0=10 / Shift+0=10 binds.
  workspaceBinds =
    let
      indices = lib.range 1 10;
    in
    lib.concatMap (n: [
      (mod (toString n) "focus-workspace" // { })  # placeholder, see below
    ]) indices
    ++ [ ];

  # The list-based form above was getting awkward.  Use a fold instead.
  workspaceFocusBinds = lib.foldl' (
    acc: n:
    let
      key = if n == 10 then "0" else toString n;
    in
    acc // (mod key "focus-workspace")
  ) { } (lib.range 1 10);

  workspaceMoveBinds = modShift "0" "move-window-to-workspace" // {
    "Mod+Shift+0".action.move-window-to-workspace = 10;
  };

  # ── Terminal applets (Mod5+key) ───────────────────────────────────────
  mkTerminalApplet =
    {
      name,
      command,
      key,
      appId ? "${name}-applet",
    }:
    {
      bind = {
        "Mod5+${key}".action.spawn = [
          "sh"
          "-c"
          ''
            if niri msg --json focused-window | ${pkgs.jq}/bin/jq -e '.app_id == "${appId}"' > /dev/null; then
              niri msg action close-window
            elif ! niri msg action focus-window "app-id='${appId}'"; then
              kitty --app-id "${appId}" ${command}
            fi
          ''
        ];
      };

      rule = {
        matches = [ { app-id = appId; } ];
        open-floating = true;
        default-column-width = {
          proportion = 0.6;
        };
        default-window-height = {
          proportion = 0.6;
        };
      };
    };
  terminalApplets = [
    (mkTerminalApplet {
      name = "volume";
      key = "V";
      command = "wiremix";
    })

    (mkTerminalApplet {
      name = "wifi";
      key = "W";
      command = "impala";
    })

    (mkTerminalApplet {
      name = "bluetooth";
      key = "Shift+B";
      command = "bluetui";
    })

    (mkTerminalApplet {
      name = "monitor";
      key = "M";
      command = "btm";
    })
  ];

  # ── Compose the full binds attrset from declarative pieces ───────────
  binds = lib.mkMerge [
    # Applications
    (mod "T" "spawn") // { "Mod+T".action.spawn = "${terminal}"; }
    (mod "B" "spawn") // { "Mod+B".action.spawn = "${browser.name}"; }
    (mod "D" "spawn") // { "Mod+D".action.spawn = sh "walker"; }
    (bindNoArg "Mod5+B" "spawn" // { "Mod5+B".action.spawn = sh "walker -m bluetooth"; })

    # Window Management
    (mod "Q" "close-window")
    (mod "F" "fullscreen-window")
    (mod "O" "toggle-overview")
    (mod "Shift+R" "spawn" // { "Mod+Shift+R".action.spawn = sh "${reloadScript}/bin/reloadScript"; })

    # Focus (HJKL)
    (mod "H" "focus-column-left")
    (mod "L" "focus-column-right")
    (mod "K" "focus-window-or-workspace-up")
    (mod "J" "focus-window-or-workspace-down")

    # Move (Shift + HJKL)
    (modShift "H" "move-column-left")
    (modShift "L" "move-column-right")
    (modShift "K" "move-window-up-or-to-workspace-up")
    (modShift "J" "move-window-down-or-to-workspace-down")

    # Stacking (vertical tiling)
    (mod "V" "consume-or-expel-window-left")
    (mod "BracketLeft" "consume-or-expel-window-left")
    (mod "BracketRight" "consume-or-expel-window-right")

    # Resize (Alt + HJKL)
    (modAlt "H" "set-column-width" "-10%")
    (modAlt "L" "set-column-width" "+10%")
    (modAlt "K" "set-window-height" "-10%")
    (modAlt "J" "set-window-height" "+10%")

    # Column operations
    (mod "C" "center-column")
    (mod "M" "maximize-column")
    (mod "Shift+M" "reset-window-height")
    (mod "Home" "focus-column-first")
    (mod "End" "focus-column-last")
    (mod "Slash" "show-hotkey-overlay")

    # Workspace navigation (vertical)
    (mod "U" "focus-workspace-down")
    (mod "I" "focus-workspace-up")
    (bindNoArg "Mod+WheelScrollDown" "focus-workspace-down")
    (bindNoArg "Mod+WheelScrollUp" "focus-workspace-up")

    # Workspace movement
    (modCtrl "U" "move-workspace-down")
    (modCtrl "I" "move-workspace-up")

    # Move column to workspace
    (modShift "U" "move-column-to-workspace-down")
    (modShift "I" "move-column-to-workspace-up")
    (modShift "WheelScrollDown" "move-column-to-workspace-down")
    (modShift "WheelScrollUp" "move-column-to-workspace-up")

    # Screenshots
    (bindNoArg "Print" "spawn" // {
      "Print".action.spawn = sh ''grim -g "$(slurp)" - | convert - -shave 1x1 PNG: - | wl-copy'';
    })
    (bindNoArg "Shift+Print" "spawn" // {
      "Shift+Print".action.spawn = sh ''grim -g "$(slurp)" - | swappy -f -'';
    })

    # Swayosd (volume + brightness)
    (swayosd { combo = "XF86AudioRaiseVolume"; flag = "output-volume raise"; extra = "--max-volume 100"; })
    (swayosd { combo = "XF86AudioLowerVolume"; flag = "output-volume lower"; extra = ""; })
    (swayosd { combo = "XF86AudioMute"; flag = "output-volume mute-toggle"; extra = ""; })
    (swayosd { combo = "XF86AudioMicMute"; flag = "input-volume mute-toggle"; extra = ""; })
    (swayosd { combo = "XF86MonBrightnessUp"; flag = "brightness raise"; extra = ""; })
    (swayosd { combo = "XF86MonBrightnessDown"; flag = "brightness lower"; extra = ""; })

    # Media keys
    (mediaKey "XF86AudioNext" "next")
    (mediaKey "XF86AudioPause" "play-pause")
    (mediaKey "XF86AudioPlay" "play-pause")
    (mediaKey "XF86AudioPrev" "previous")

    # Numeric workspace focus (1-10) + Shift+0 -> 10
    workspaceFocusBinds
    (bindWithArg "Mod+Shift+0" "move-window-to-workspace" 10)

    # Terminal applets
    (builtins.foldl' (acc: val: acc // val.bind) { } terminalApplets)
  ];
in
{
  imports = [ ./waybar-vertical.nix ];
  home.packages = with pkgs; [
    impala
    brightnessctl
    xwayland-satellite
    mpris-notifier
    awww
    waybar
    swaynotificationcenter
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
  ];

  services.swayosd = {
    enable = true;
  };
  xdg.configFile."swayosd/style.css".text = ''
    window#osd {
        /* The main background of the overlay */
        background: ${themeLib.semantic.bg};
        border-radius: 12px; /* Optional: smooth out the corners */
    }

    progress {
        background: ${themeLib.semantic.fg};
    }
  '';

  services.hypridle = {
    enable = true;
    settings = {
      listener = [
        {
          timeout = 300; # 5 min
          on-timeout = "${prelockScript}/bin/prelockScript";
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
          on-timeout = ''${pkgs.bash}/bin/bash -c 'if grep -q "open" /proc/acpi/button/lid/*/state 2>/dev/null; then systemctl suspend; fi' '';
        }
      ];
    };
  };

  programs.niri = {
    package = pkgs.niri-unstable;
    enable = true;
    settings = {
      input = {
        keyboard.xkb.layout = "latam";
        touchpad.natural-scroll = true;
      };
      outputs = {
        "eDP-1".scale = 1.0;
      };

      overview = {
        backdrop-color = "${themeLib.semantic.bg}"; # Uses your theme's base color
      };
      layout = {

        gaps = 16;
        always-center-single-column = true;

        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 1.0 / 2.0; }
          { proportion = 2.0 / 3.0; }
        ];

        default-column-width = {
          proportion = 0.5;
        };

        focus-ring = {
          enable = true;
          width = 8;
          active.gradient = {
            angle = 45;
            from = "${colors.focused}";
            to = "${colors.alt}";
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
          matches = [ { app-id = "^${terminal}$"; } ];
          opacity = 0.9;
        }
        {
          matches = [ { app-id = "^zen$"; } ];
          open-maximized = false;
          open-fullscreen = false;
        }
      ]
      ++ (map (x: x.rule) terminalApplets);

      inherit binds;
    };
  };
}
