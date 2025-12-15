{ lib, pkgs, browser, config, colors, ... }:

let
  up = "k";
  down = "j";
  left = "h";
  right = "l";
  monitorHeight = 1600;
  monitorWidth = 2560;
  terminal = "ghostty";

  startupScript = pkgs.writeShellScriptBin "startupScript" ''
    udiskie &
    keyd-application-mapper -d &
    swww-daemon &
    legion-kb-rgb set -e Static -c 100,100,100,100,100,100,100,100,100,100,100,100
    systemctl --user restart pipewire pipewire-pulse &
  '';

  reloadScript = pkgs.writeShellScriptBin "reloadScript" ''
    pkill waybar &
    sleep 0.2
    swww img ~/Pictures/wallpapers/${colors.theme}.jpg --transition-type any &
    waybar & disown
  '';

  prelockScript = pkgs.writeShellScriptBin "prelockScript" ''
    tmpbg="/tmp/screen.png"
    ${pkgs.grim}/bin/grim "$tmpbg"
    ${pkgs.imagemagick}/bin/magick "$tmpbg" -blur 0x5 -fill "#${colors.base}" -colorize 50% "$tmpbg"
  '';
in {
  programs.niri.enable = true;
  programs.niri.settings = {
    binds = with config.lib.niri.actions; {
      "XF86AudioRaiseVolume".action =
        spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
      "XF86AudioLowerVolume".action =
        spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";

      "Mod+D".action = spawn "fuzzel";
      "Mod+1".action = focus-workspace 1;

      "Mod+Shift+E".action = quit;
      "Mod+Ctrl+Shift+E".action = quit { skip-confirmation = true; };

      "Mod+Plus".action = set-column-width "+10%";

layout =  {
    gaps= 16

    // When to center a column when changing focus, options are:
    // - "never", default behavior, focusing an off-screen column will keep at the left
    //   or right edge of the screen.
    // - "always", the focused column will always be centered.
    // - "on-overflow", focusing a column will center it if it doesn't fit
    //   together with the previously focused column.
    center-focused-column "never"

    // You can customize the widths that "switch-preset-column-width" (Mod+R) toggles between.
    preset-column-widths {
        // Proportion sets the width as a fraction of the output width, taking gaps into account.
        // For example, you can perfectly fit four windows sized "proportion 0.25" on an output.
        // The default preset widths are 1/3, 1/2 and 2/3 of the output.
        proportion 0.33333
        proportion 0.5
        proportion 0.66667

        // Fixed sets the width in logical pixels exactly.
        // fixed 1920
    }

    // You can also customize the heights that "switch-preset-window-height" (Mod+Shift+R) toggles between.
    // preset-window-heights { }

    // You can change the default width of the new windows.
    default-column-width { proportion 0.5; }
    // If you leave the brackets empty, the windows themselves will decide their initial width.
    // default-column-width {}

    // By default focus ring and border are rendered as a solid background rectangle
    // behind windows. That is, they will show up through semitransparent windows.
    // This is because windows using client-side decorations can have an arbitrary shape.
    //
    // If you don't like that, you should uncomment `prefer-no-csd` below.
    // Niri will draw focus ring and border *around* windows that agree to omit their
    // client-side decorations.
    //
    // Alternatively, you can override it with a window rule called
    // `draw-border-with-background`.

    // You can change how the focus ring looks.
    focus-ring {
        // Uncomment this line to disable the focus ring.
        // off

        // How many logical pixels the ring extends out from the windows.
        width 4

        // Colors can be set in a variety of ways:
        // - CSS named colors: "red"
        // - RGB hex: "#rgb", "#rgba", "#rrggbb", "#rrggbbaa"
        // - CSS-like notation: "rgb(255, 127, 0)", rgba(), hsl() and a few others.

        // Color of the ring on the active monitor.
        active-color "#7fc8ff"

        // Color of the ring on inactive monitors.
        inactive-color "#505050"

        // You can also use gradients. They take precedence over solid colors.
        // Gradients are rendered the same as CSS linear-gradient(angle, from, to).
        // The angle is the same as in linear-gradient, and is optional,
        // defaulting to 180 (top-to-bottom gradient).
        // You can use any CSS linear-gradient tool on the web to set these up.
        // Changing the color space is also supported, check the wiki for more info.
        //
        // active-gradient from="#80c8ff" to="#bbddff" angle=45

        // You can also color the gradient relative to the entire view
        // of the workspace, rather than relative to just the window itself.
        // To do that, set relative-to="workspace-view".
        //
        // inactive-gradient from="#505050" to="#808080" angle=45 relative-to="workspace-view"
    }

    // You can also add a border. It's similar to the focus ring, but always visible.
    border {
        // The settings are the same as for the focus ring.
        // If you enable the border, you probably want to disable the focus ring.
        off

        width 4
        active-color "#ffc87f"
        inactive-color "#505050"

        // Color of the border around windows that request your attention.
        urgent-color "#9b0000"

        // active-gradient from="#ffbb66" to="#ffc880" angle=45 relative-to="workspace-view"
        // inactive-gradient from="#505050" to="#808080" angle=45 relative-to="workspace-view"
    }
    };
  };
}
